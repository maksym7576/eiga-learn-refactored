// Серверний (повна відповідь) обробник запиту до Gemini
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
        final data = jsonDecode(response.body);
        if (data['candidates'] != null &&
            data['candidates'][0]['content'] != null) {
          String cleanedResponse =
          data['candidates'][0]['content']['parts'][0]['text']
              .toString()
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();

          await _responseParse(cleanedResponse);
        } else {
          throw GeminiGeneralException("Empty response from Gemini");
        }
      } else {
        final errorBody = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        final errorMessage = (errorBody is Map && errorBody['error'] != null)
            ? (errorBody['error']['message'] ?? 'Unknown error')
            : 'Unknown error';
        final int code = response.statusCode;

        if (code == 403 || code == 400) {
          throw GeminiIncorrectTokenException("Token is incorrect");
        } else if (code == 429) {
          throw GeminiModelExpiredException('Please change a model');
        } else if (code == 500 || code == 503 || code == 504) {
          throw GeminiServerException('Server error');
        } else {
          throw GeminiGeneralException('Request failed: $errorMessage');
        }
      }
    } catch (error, stackTrace) {
      bool isTerminal = !(error is GeminiServerException || error is http.ClientException);
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
    // Парсимо весь JSON як список об'єктів
    final List<dynamic> phrasesJsonData = jsonDecode(jsonResponse);

    for (var phrasesData in phrasesJsonData) {
      final int phraseId = phrasesData['phraseId'];
      final List<dynamic> blocks = phrasesData['blocks'] ?? [];

      final phrase = await phraseService.getPhraseById(phraseId);
      if (phrase == null) continue;

      for (var block in blocks) {
        final contentSignature = "${phraseId}_${block['b_pos']}";
        final existingBlock = await blockService.getBlockByContentSignature(contentSignature);

        if (existingBlock != null) {
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
        aiRequestNotifier.appendLog('Block created ID: $blockId');
        aiRequestNotifier.incrementProgress();

        final List<dynamic> wordDataJson = block['word'] ?? [];

        for (var wordData in wordDataJson) {
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
        }
      }

      await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId);
    }
  }
}