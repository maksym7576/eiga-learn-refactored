// PhraseResponseHandler.dart
import 'dart:convert';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/services/models_services/blockService.dart';
import 'package:eiga/backend/services/models_services/phraseService.dart';
import 'package:eiga/backend/services/models_services/wordService.dart';
import 'package:eiga/backend/exeption/AiUserFacingError.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../../../providers/AiRequestPhase.dart';
import 'utils/response_parser_utils.dart';
import 'word_reading_normalizer.dart';

class PhraseResponseHandler {
  final PhraseService phraseService;
  final BlockService blockService;
  final WordService wordService;
  final void Function() onProgress;

  final WordReadingNormalizer _normalizer = WordReadingNormalizer();

  PhraseResponseHandler({
    required this.phraseService,
    required this.blockService,
    required this.wordService,
    void Function()? onProgress,
  }) : onProgress = onProgress ?? _noopProgress;

  static void _noopProgress() {}

  void _log(String message) {
    assert(() {
      debugPrint('[PhraseResponseHandler] $message');
      return true;
    }());
  }

  Future<AiRequestResult> processResponse(String jsonResponse) async {
    dynamic parsed;
    try {
      parsed = jsonDecode(jsonResponse);
    } catch (e) {
      _log('[ParseError] ${e.toString()}');
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final List<dynamic> entries;
    if (parsed is List) {
      entries = parsed;
    } else if (parsed is Map) {
      entries = [parsed];
    } else {
      _log('[ParseError] Unexpected JSON root type: ${parsed.runtimeType}');
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final failedPhraseIds = <String>[];

    for (final entry in entries) {
      final phraseId = await processPhraseEntryData(entry);
      if (phraseId == null) continue; // повністю пропущено (malformed) — не рахуємо як "фразу", яка провалилась
      if (!phraseId.ok) {
        failedPhraseIds.add(phraseId.phraseId.toString());
      }
    }

    if (failedPhraseIds.isEmpty) {
      return AiRequestResult.success();
    }
    return AiRequestResult.partialSuccess(failedPhraseIds);
  }
  Future<_PhraseOutcome?> processPhraseEntryData(
      dynamic phrasesData, {
        Set<String>? dedupSignatures,
      }) async {
    if (phrasesData == null || phrasesData is! Map) {
      _log('Handler -> skipped: entry is not a Map');
      return null;
    }

    final int phraseId = ResponseParserUtils.parseId(phrasesData['phraseId']);
    if (phraseId <= 0) {
      _log(
        'Handler -> skipped: invalid phraseId (${phrasesData['phraseId']})',
      );
      return null;
    }

    final rawBlocks = phrasesData['blocks'];
    if (rawBlocks is! List || rawBlocks.isEmpty) {
      _log('Handler -> Phrase $phraseId has no blocks, skipped');
      return _PhraseOutcome(phraseId: phraseId, ok: false);
    }

    final phrase = await phraseService.getPhraseById(phraseId);
    if (phrase == null) {
      _log('Handler -> Phrase $phraseId not found in DB, skipped');
      return _PhraseOutcome(phraseId: phraseId, ok: false);
    }

    final Set<String> referenceVersionKeys = _normalizer.collectReferenceVersionKeys(rawBlocks);

    final firstWordPos = _normalizer.findFirstWordPosition(rawBlocks);

    bool phraseHadErrors = false;

    for (var block in rawBlocks) {
      try {
        if (block is! Map || !block.containsKey('b_pos') || !block.containsKey('tr')) {
          _log(
            'Handler -> skipped malformed block for phrase $phraseId: $block',
          );
          phraseHadErrors = true;
          continue;
        }

        final int? blockPos = block['b_pos'] is int
            ? block['b_pos'] as int
            : int.tryParse(block['b_pos'].toString());
        if (blockPos == null) {
          _log(
            'Handler -> skipped block with invalid b_pos for phrase $phraseId',
          );
          phraseHadErrors = true;
          continue;
        }

        final contentSignature = "${phraseId}_$blockPos";

        if (dedupSignatures != null && dedupSignatures.contains(contentSignature)) {
          continue;
        }
        dedupSignatures?.add(contentSignature);

        final existingBlock = await blockService.getBlockByContentSignature(contentSignature);
        if (existingBlock != null) {
          _log('Handler -> block already exists: $contentSignature');
          continue;
        }

        final newBlock = BlockObject(
          phraseId: phraseId,
          blockTranslation: block['tr']?.toString() ?? '',
          translatedPositionIndex: ResponseParserUtils.parseIntList(block['tr_pos']),
          blockPositionIndex: blockPos,
          contentSignature: contentSignature,
          colorHex: ResponseParserUtils.parseColorHex(block['colorHex']),
        );

        final blockId = await blockService.createBlock(blockObject: newBlock);
        _log('Handler -> Block created ID: $blockId for Phrase: $phraseId');
        onProgress();

        final List<dynamic> wordDataJson = block['word'] is List ? block['word'] as List : [];

        for (var wordData in wordDataJson) {
          try {
            if (wordData is! Map) {
              _log('Handler -> skipped non-map word entry: $wordData');
              phraseHadErrors = true;
              continue;
            }
            final Map<String, dynamic> map = Map<String, dynamic>.from(wordData);

            final int? currentWordPos = map['w_pos'] is int
                ? map['w_pos'] as int
                : int.tryParse(map['w_pos']?.toString() ?? '');

            // Це те саме слово, що знайшли як "найперше" у фразі?
            final bool isFirstWordInPhrase = firstWordPos != null &&
                blockPos == firstWordPos.blockPos &&
                currentWordPos == firstWordPos.wordPos;

            final newWord = WordObject(blockId: blockId)
              ..wordPosition = currentWordPos
              ..versions = _normalizer.normalizeWordVersions(
                map,
                referenceVersionKeys,
                isFirstWordInPhrase: isFirstWordInPhrase,
              );

            await wordService.createWord(wordObject: newWord);
          } catch (e) {
            _log('Handler -> word parse/create error: $e');
            phraseHadErrors = true;
          }
        }
      } catch (e) {
        _log('Handler -> block processing error for phrase $phraseId: $e');
        phraseHadErrors = true;
      }
    }

    await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId);

    return _PhraseOutcome(phraseId: phraseId, ok: !phraseHadErrors);
  }

  Future<AiRequestResult> saveTranslationsResponse(Map<String, dynamic> parsedJson) async {
    final lines = parsedJson['lines'];
    if (lines is! List) {
      _log('[ParseError] saveTranslationsResponse: "lines" is not a List');
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final failedPhraseIds = <String>[];

    for (var lineData in lines) {
      if (lineData is! Map<String, dynamic>) {
        continue;
      }
      final int phraseId = ResponseParserUtils.parseId(lineData['id']);
      final String translation = lineData['translation']?.toString() ?? '';

      if (phraseId <= 0 || translation.isEmpty) {
        if (phraseId > 0) failedPhraseIds.add(phraseId.toString());
        continue;
      }

      try {
        await phraseService.updateTranslatedPhraseText(phraseId, translation);
        _log('Handler -> Translation added to Phrase: $phraseId');
      } catch (e) {
        _log('Handler -> failed to save translation for Phrase $phraseId: $e');
        failedPhraseIds.add(phraseId.toString());
      }
    }

    if (failedPhraseIds.isEmpty) {
      return AiRequestResult.success();
    }
    return AiRequestResult.partialSuccess(failedPhraseIds);
  }

}

class _PhraseOutcome {
  final int phraseId;
  final bool ok;
  const _PhraseOutcome({required this.phraseId, required this.ok});
}