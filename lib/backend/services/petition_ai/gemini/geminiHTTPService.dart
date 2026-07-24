// Серверний (повна відповідь) обробник запиту до Gemini (покращений)
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/exeption/geminiException.dart';
import 'package:eiga/backend/services/models_services/blockService.dart';
import 'package:eiga/backend/services/models_services/phraseService.dart';
import 'package:eiga/backend/services/models_services/wordService.dart';

import '../../../../providers/AIRequestStatusProvider.dart';

class GeminiHTTPService {
  final AiRequestNotifier aiRequestNotifier;
  final PhraseService phraseService;
  final BlockService blockService;
  final WordService wordService;

  GeminiHTTPService({
    required this.aiRequestNotifier,
    required this.phraseService,
    required this.blockService,
    required this.wordService,
  });

  Future<void> sendAndParseRequest(String url, String prompt) async {
    try {
      final Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      };

      aiRequestNotifier.setSending();

      final response = await http
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      )
          .timeout(
        const Duration(seconds: 160),
        onTimeout: () {
          throw Exception("Gemini request time out");
        },
      );

      if (response.statusCode == 200) {
        final bodyText = response.body ?? '';
        if (bodyText.trim().isEmpty) {
          throw GeminiGeneralException("Empty response body from Gemini");
        }

        final data = jsonDecode(bodyText);
        if (data is Map && data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null && candidate['content']['parts'] != null && candidate['content']['parts'].isNotEmpty) {
            String rawText = candidate['content']['parts'][0]['text'].toString();

            // Очищення, якщо модель поклала ```json ... ```
            String cleanedResponse = rawText.replaceAll('```json', '').replaceAll('```', '').trim();

            await _responseParse(cleanedResponse);
            return;
          }
        }

        throw GeminiGeneralException("Unexpected response shape from Gemini: ${response.body}");
      } else {
        Map<String, dynamic> errorBody = {};
        try {
          if (response.body.isNotEmpty) {
            final decoded = jsonDecode(response.body);
            if (decoded is Map<String, dynamic>) errorBody = decoded;
          }
        } catch (_) {}

        final errorMessage = (errorBody.isNotEmpty && errorBody['error'] != null)
            ? (errorBody['error']['message'] ?? 'Unknown error')
            : 'Unknown error';
        final int code = response.statusCode;

        if (code == 403 || code == 400) {
          aiRequestNotifier.setErrorWithDetails(
            Exception('Token or auth error'),
            message: 'Token is incorrect or request malformed',
            httpCode: code,
            type: AiErrorType.auth,
          );
          throw GeminiIncorrectTokenException("Token is incorrect");
        } else if (code == 429) {
          aiRequestNotifier.setErrorWithDetails(
            Exception('Rate limit / quota exceeded'),
            message: 'Rate limit / model expired',
            httpCode: code,
            type: AiErrorType.rateLimit,
          );
          throw GeminiModelExpiredException('Please change a model');
        } else if (code == 500 || code == 503 || code == 504) {
          aiRequestNotifier.setErrorWithDetails(
            Exception('Server error'),
            message: 'Server error from Gemini',
            httpCode: code,
            type: AiErrorType.server,
          );
          throw GeminiServerException('Server error');
        } else {
          aiRequestNotifier.setErrorWithDetails(
            Exception('Unknown error code $code'),
            message: 'Request failed: $errorMessage',
            httpCode: code,
            type: AiErrorType.unknown,
          );
          throw GeminiGeneralException('Request failed: $errorMessage');
        }
      }
    } catch (error, stackTrace) {
      final bool isTerminal = !(error is GeminiServerException || error is http.ClientException);
      aiRequestNotifier.reportError(
        error,
        message: error is Exception ? error.toString() : 'Unknown error occurred',
        stackTrace: stackTrace,
        terminal: isTerminal,
      );
      rethrow;
    }
  }

  Future<void> _responseParse(String jsonResponse) async {
    try {
      // Парсимо весь JSON як список об'єктів або як один об'єкт
      final parsed = jsonDecode(jsonResponse);

      if (parsed is List) {
        for (var phrasesData in parsed) {
          await _processPhraseEntry(phrasesData);
        }
      } else if (parsed is Map) {
        await _processPhraseEntry(parsed);
      } else {
        throw FormatException('Unexpected JSON root type');
      }
    } catch (e, st) {
      aiRequestNotifier.appendLog('[ParseError] ${e.toString()}');
      aiRequestNotifier.reportError(e, message: 'Failed to parse Gemini response', stackTrace: st, terminal: true);
      rethrow;
    }
  }

  Future<void> _processPhraseEntry(dynamic phrasesData) async {
    if (phrasesData == null) return;
    final int phraseId = (phrasesData['phraseId'] is int) ? phrasesData['phraseId'] as int : int.tryParse(phrasesData['phraseId'].toString()) ?? -1;
    if (phraseId <= 0) return;

    final List<dynamic> blocks = phrasesData['blocks'] ?? [];

    final phrase = await phraseService.getPhraseById(phraseId);
    if (phrase == null) return;

    for (var block in blocks) {
      if (!block.containsKey('b_pos') || !block.containsKey('tr')) continue;

      final contentSignature = "${phraseId}_${block['b_pos']}";
      final existingBlock = await blockService.getBlockByContentSignature(contentSignature);

      if (existingBlock != null) {
        aiRequestNotifier.appendLog('HTTP -> block already exists: $contentSignature');
        continue;
      }

      final newBlock = BlockObject(
        phraseId: phraseId,
        blockTranslation: block['tr'] as String,
        translatedPositionIndex: List<int>.from(block['tr_pos'] ?? []).toSet().toList(),
        blockPositionIndex: block['b_pos'] as int,
        contentSignature: contentSignature,
        colorHex: block['colorHex'] ?? "#FFFFFF",
      );

      final blockId = await blockService.createBlock(blockObject: newBlock);
      aiRequestNotifier.appendLog('HTTP -> Block created ID: $blockId for Phrase: $phraseId');
      aiRequestNotifier.incrementProgress();

      final List<dynamic> wordDataJson = block['word'] ?? [];

      for (var wordData in wordDataJson) {
        try {
          final Map<String, dynamic> map = Map<String, dynamic>.from(wordData);

          final newWord = WordObject(blockId: blockId)
            ..wordPosition = map['w_pos'] as int?
            ..versions = map.entries
                .where((entries) => entries.key != 'w_pos')
                .where((entries) => entries.value != null && entries.value.toString().isNotEmpty)
                .map((entries) => ReadingItem(
              key: entries.key,
              text: entries.value.toString(),
            ))
                .toList();

          await wordService.createWord(wordObject: newWord);
        } catch (e) {
          aiRequestNotifier.appendLog('HTTP -> word parse/create error: $e');
        }
      }
    }

    await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId);
  }
}