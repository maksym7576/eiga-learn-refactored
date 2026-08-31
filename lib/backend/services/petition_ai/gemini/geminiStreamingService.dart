// GeminiStreamingService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:eiga/backend/exeption/geminiException.dart';
import '../../../../providers/AiRequestPhase.dart';
import '../../../exeption/AiUserFacingError.dart';
import '../parsers/PhraseResponseHandler.dart';

class GeminiStreamingService {
  final PhraseResponseHandler phraseResponseHandler;

  final void Function()? onStart;
  final void Function(String message)? onLog;

  final Set<String> _processedBlockSignatures = {};
  final Set<int> _processedPhraseIds = {};
  final Set<int> _failedPhraseIds = {};

  GeminiStreamingService({
    required this.phraseResponseHandler,
    this.onStart,
    this.onLog,
  });

  void _internalLog(String message) {
    onLog?.call(message);
    debugPrint('[GeminiStreamingService] $message');
  }

  Future<AiRequestResult> fetchParseAndSaveData(String url, String prompt, {List<int> expectedIds = const []}) async {
    _processedBlockSignatures.clear();
    _processedPhraseIds.clear();
    _failedPhraseIds.clear();

    _internalLog('--- START STREAMING RESPONSE ---');
    _internalLog('Expected IDs: $expectedIds');

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
      onStart?.call();

      client = http.Client();
      final streamedResponse = await client.send(request).timeout(
        const Duration(seconds: 160),
        onTimeout: () {
          throw Exception("Gemini stream request time out");
        },
      );

      if (streamedResponse.statusCode != 200) {
        final errorString = await streamedResponse.stream.bytesToString();
        // Reset all because the request failed
        await phraseResponseHandler.phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
        _handleHttpError(streamedResponse.statusCode, errorString);
      }

      final StringBuffer fullTextBuffer = StringBuffer();
      final stream = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (var line in stream) {
        if (!line.startsWith('data: ')) continue;
        final dataStr = line.substring(6).trim();
        if (dataStr.isEmpty) continue;

        try {
          final jsonData = jsonDecode(dataStr);
          final String? newTextChunk = _extractTextChunk(jsonData);
          if (newTextChunk != null) {
            fullTextBuffer.write(newTextChunk);
            await _extractAndSaveReadyObjects(fullTextBuffer);
          }
        } catch (e) {
          _internalLog('[PartialParseErr] ${e.toString()}');
        }
      }

      await _extractAndSaveReadyObjects(fullTextBuffer);

      // Detection of missing IDs
      final missingIds = <int>[];
      for (final expectedId in expectedIds) {
        if (!_processedPhraseIds.contains(expectedId)) {
          _internalLog('[MISSING] Phrase $expectedId not found in stream.');
          missingIds.add(expectedId);
        }
      }

      if (missingIds.isNotEmpty) {
        _internalLog('Resetting status for ${missingIds.length} missing phrases in stream.');
        await phraseResponseHandler.phraseService.resetPhrasesTranslationStatusByIds(missingIds);
      }

      final finalFailedIds = {..._failedPhraseIds, ...missingIds}.toList();

      _internalLog('Processed IDs: ${_processedPhraseIds.toList()}');
      _internalLog('Failed/Missing IDs: $finalFailedIds');
      _internalLog('--- END STREAMING RESPONSE ---');

      return finalFailedIds.isEmpty
          ? AiRequestResult.success()
          : AiRequestResult.partialSuccess(finalFailedIds);
    } catch (error) {
      _internalLog('[StreamFatalErr] ${error.toString()}');
      // On fatal error, ensure all remaining expected IDs are reset
      final List<int> idsToReset = expectedIds.where((id) => !_processedPhraseIds.contains(id)).toList();
      if (idsToReset.isNotEmpty) {
        await phraseResponseHandler.phraseService.resetPhrasesTranslationStatusByIds(idsToReset);
      }
      return AiRequestResult.failure(_resolveErrorType(error));
    } finally {
      client?.close();
    }
  }

  String? _extractTextChunk(dynamic jsonData) {
    if (jsonData is! Map) return null;
    final candidates = jsonData['candidates'];
    if (candidates == null || candidates.isEmpty) return null;
    final content = candidates[0]['content'];
    if (content == null || content['parts'] == null || content['parts'].isEmpty) return null;
    return content['parts'][0]['text']?.toString();
  }

  Future<void> _extractAndSaveReadyObjects(StringBuffer buffer) async {
    final raw = buffer.toString();
    int depth = 0;
    int startIndex = -1;
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
      Map<String, dynamic>? parsedMap;
      List? parsedList;

      try {
        final decoded = jsonDecode(p.text);
        if (decoded is Map<String, dynamic>) {
          parsedMap = decoded;
        } else if (decoded is List) {
          parsedList = decoded;
        }
      } catch (e) {
        removedUntil = p.end;
        continue;
      }

      if (parsedMap != null && parsedMap.containsKey('phraseId') && parsedMap.containsKey('blocks')) {
        await _processOnePhrase(parsedMap);
      } else if (parsedList != null) {
        for (var single in parsedList) {
          if (single is Map<String, dynamic> &&
              single.containsKey('phraseId') &&
              single.containsKey('blocks')) {
            await _processOnePhrase(single);
          }
        }
      }
      removedUntil = p.end;
    }

    final remaining = raw.substring(removedUntil);
    buffer.clear();
    buffer.write(remaining);
  }

  Future<void> _processOnePhrase(Map<String, dynamic> entry) async {
    final idStr = entry['phraseId']?.toString() ?? '0';
    final id = int.tryParse(idStr) ?? 0;
    
    if (id > 0) _processedPhraseIds.add(id);

    try {
      final outcome = await phraseResponseHandler.processPhraseEntryData(
        entry,
        dedupSignatures: _processedBlockSignatures,
      );
      if (outcome != null && !outcome.ok) {
        _failedPhraseIds.add(id);
      }
    } catch (e) {
      if (id > 0) _failedPhraseIds.add(id);
      _internalLog('[PhraseProcessErr:$id] ${e.toString()}');
    }
  }

  void _handleHttpError(int code, String body) {
    Map<String, dynamic> errorBody = {};
    try {
      if (body.isNotEmpty) {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) errorBody = decoded;
      }
    } catch (_) {}

    final errorMessage = (errorBody['error'] != null)
        ? (errorBody['error']['message'] ?? 'Unknown error')
        : 'Unknown error';

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

  AiErrorType _resolveErrorType(Object error) {
    if (error is GeminiException) return error.type;
    if (error is http.ClientException) return AiErrorType.server;
    if (error.toString().contains('time out')) return AiErrorType.server;
    return AiErrorType.unknown;
  }
}

class _ExtractedPiece {
  final String text;
  final int start;
  final int end;
  _ExtractedPiece(this.text, this.start, this.end);
}
