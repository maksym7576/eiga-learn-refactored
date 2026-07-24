import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/exeption/geminiException.dart';
import 'package:eiga/backend/services/models_services/blockService.dart';
import 'package:eiga/backend/services/models_services/phraseService.dart';
import 'package:eiga/backend/services/models_services/wordService.dart';

import '../../../../providers/AIRequestStatusProvider.dart';

class GeminiStreamingService {
  final AiRequestNotifier aiRequestNotifier;
  final PhraseService phraseService;
  final BlockService blockService;
  final WordService wordService;

  final Set<String> _processedBlockSignatures = {};

  GeminiStreamingService({
    required this.aiRequestNotifier,
    required this.phraseService,
    required this.blockService,
    required this.wordService,
  });

  Future<void> sendStreamAndParseRequest(String url, String prompt) async {
    _processedBlockSignatures.clear();
    final streamUrl = url.contains('?') ? '$url&alt=sse' : '$url?alt=sse';

    final requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    };

    final request = http.Request('POST', Uri.parse(streamUrl))
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode(requestBody);

    http.Client? client;
    try {
      aiRequestNotifier.setStreamingResponse();

      client = http.Client();
      final streamedResponse = await client.send(request).timeout(
        const Duration(seconds: 160),
        onTimeout: () {
          throw Exception("Gemini stream request time out");
        },
      );

      if (streamedResponse.statusCode != 200) {
        final errorString = await streamedResponse.stream.bytesToString();
        _handleErrorStatusCode(streamedResponse.statusCode, errorString);
      }

      final StringBuffer fullTextBuffer = StringBuffer();

      // Використовуємо LineSplitter для коректної склейки розірваних рядків SSE
      final stream = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (var line in stream) {
        if (line.startsWith('data: ')) {
          final dataStr = line.substring(6).trim();
          if (dataStr.isEmpty) continue;

          try {
            final jsonData = jsonDecode(dataStr);
            if (jsonData['candidates'] != null &&
                jsonData['candidates'].isNotEmpty &&
                jsonData['candidates'][0]['content'] != null) {

              final String newTextChunk = jsonData['candidates'][0]['content']['parts'][0]['text'];
              fullTextBuffer.write(newTextChunk);

              await _extractAndSaveReadyObjects(fullTextBuffer);
            }
          } catch (e) {
            aiRequestNotifier.appendLog('[PartialParseErr] $e');
          }
        }
      }

      await _extractAndSaveReadyObjects(fullTextBuffer);
      aiRequestNotifier.success();
    } catch (error, stackTrace) {
      bool isTerminal = !(error is GeminiServerException || error is http.ClientException);
      aiRequestNotifier.reportError(
        error,
        message: error is Exception ? error.toString() : 'Streaming error occurred',
        stackTrace: stackTrace,
        terminal: isTerminal,
      );
      rethrow;
    } finally {
      client?.close();
    }
  }

  Future<void> _extractAndSaveReadyObjects(StringBuffer buffer) async {
    final raw = buffer.toString();
    int depth = 0;
    int startIndex = -1;

    // Прапорці для ігнорування дужок всередині текстових значень
    bool insideString = false;
    bool isEscape = false;

    final List<_ExtractedPiece> readyPieces = [];

    for (int i = 0; i < raw.length; i++) {
      final ch = raw[i];

      if (insideString) {
        if (isEscape) {
          isEscape = false;
        } else if (ch == '\\') {
          isEscape = true;
        } else if (ch == '"') {
          insideString = false;
        }
        continue;
      }

      if (ch == '"') {
        insideString = true;
      } else if (ch == '{') {
        if (depth == 0) startIndex = i;
        depth++;
      } else if (ch == '}') {
        depth--;
        if (depth == 0 && startIndex != -1) {
          final piece = raw.substring(startIndex, i + 1);
          readyPieces.add(_ExtractedPiece(piece, startIndex, i + 1));
          startIndex = -1;
        }
      }
    }

    if (readyPieces.isEmpty) return;

    int removedUntil = 0;
    for (var p in readyPieces) {
      try {
        final parsed = jsonDecode(p.text);
        if (parsed is Map && parsed.containsKey('phraseId') && parsed.containsKey('blocks')) {
          await _saveParsedData(parsed);
        }
      } catch (_) {
        // ігноруємо невалідні секції
      }
      removedUntil = p.end;
    }

    final remaining = raw.substring(removedUntil);
    buffer.clear();
    buffer.write(remaining);
  }

  Future<void> _saveParsedData(dynamic phrasesData) async {
    final int phraseId = phrasesData['phraseId'];
    final List<dynamic> blocks = phrasesData['blocks'] ?? [];

    final phrase = await phraseService.getPhraseById(phraseId);
    if (phrase == null) return;

    for (var block in blocks) {
      if (!block.containsKey('b_pos') || !block.containsKey('tr')) continue;

      final contentSignature = "${phraseId}_${block['b_pos']}";
      if (_processedBlockSignatures.contains(contentSignature)) continue;

      // Додаємо сигнатуру до перевірки в БД, щоб інші чанки стріму не почали її обробляти
      _processedBlockSignatures.add(contentSignature);

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
      aiRequestNotifier.appendLog('Stream -> Block created ID: $blockId for Phrase: $phraseId');
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

  void _handleErrorStatusCode(int code, String body) {
    final Map<String, dynamic> errorBody = body.isNotEmpty ? jsonDecode(body) : {};
    final errorMessage = (errorBody['error'] != null) ? (errorBody['error']['message'] ?? 'Unknown error') : 'Unknown error';

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
}

class _ExtractedPiece {
  final String text;
  final int start;
  final int end;
  _ExtractedPiece(this.text, this.start, this.end);
}