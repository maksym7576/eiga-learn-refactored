// Streaming service для Gemini (покращений, оновлює БД в реальному часі)
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
          } catch (e, st) {
            aiRequestNotifier.appendLog('[PartialParseErr] ${e.toString()}');
            aiRequestNotifier.recordEvent('Partial parse error: ${e.toString()}', kind: 'parse');
          }
        }
      }

      await _extractAndSaveReadyObjects(fullTextBuffer);
      aiRequestNotifier.success();
    } catch (error, stackTrace) {
      final bool isTerminal = !(error is GeminiServerException || error is http.ClientException);
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
        } else if (parsed is List) {
          for (var single in parsed) {
            if (single is Map && single.containsKey('phraseId') && single.containsKey('blocks')) {
              await _saveParsedData(single);
            }
          }
        }
      } catch (e) {
        // ігноруємо невалідні секції, але логнемо
        aiRequestNotifier.appendLog('[StreamParseIgnored] ${e.toString()}');
      }
      removedUntil = p.end;
    }

    final remaining = raw.substring(removedUntil);
    buffer.clear();
    buffer.write(remaining);
  }

  Future<void> _saveParsedData(dynamic phrasesData) async {
    final int phraseId = (phrasesData['phraseId'] is int) ? phrasesData['phraseId'] as int : int.tryParse(phrasesData['phraseId'].toString()) ?? -1;
    if (phraseId <= 0) return;

    final List<dynamic> blocks = phrasesData['blocks'] ?? [];

    final phrase = await phraseService.getPhraseById(phraseId);
    if (phrase == null) return;

    for (var block in blocks) {
      try {
        if (!block.containsKey('b_pos') || !block.containsKey('tr')) continue;

        final contentSignature = "${phraseId}_${block['b_pos']}";
        if (_processedBlockSignatures.contains(contentSignature)) continue;

        // Щоб уникнути race condition у межах одного стріму
        _processedBlockSignatures.add(contentSignature);

        final existingBlock = await blockService.getBlockByContentSignature(contentSignature);
        if (existingBlock != null) {
          aiRequestNotifier.appendLog('Stream -> block already exists: $contentSignature');
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
            aiRequestNotifier.appendLog('Stream -> word parse/create error: $e');
          }
        }
      } catch (e, st) {
        aiRequestNotifier.appendLog('Stream -> block processing error: $e');
        aiRequestNotifier.recordEvent('Stream block error: ${e.toString()}', kind: 'error');
      }
    }

    await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId);
  }

  void _handleErrorStatusCode(int code, String body) {
    Map<String, dynamic> errorBody = {};
    try {
      if (body.isNotEmpty) {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) errorBody = decoded;
      }
    } catch (_) {}

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