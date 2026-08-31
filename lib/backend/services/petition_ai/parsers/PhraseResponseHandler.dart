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
    debugPrint('[PhraseResponseHandler] $message');
  }

  Future<AiRequestResult> processResponse(String jsonResponse, {List<int> expectedIds = const []}) async {
    _log('--- START PROCESS RESPONSE ---');
    _log('Expected IDs: $expectedIds');

    dynamic parsed;
    try {
      parsed = jsonDecode(jsonResponse);
    } catch (e) {
      _log('[CRITICAL] JSON Decode failed: ${e.toString()}');
      _log('Raw JSON start: ${jsonResponse.length > 500 ? jsonResponse.substring(0, 500) : jsonResponse}');
      // Reset all expected IDs since we can't parse anything
      await phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final List<dynamic> entries;
    if (parsed is List) {
      entries = parsed;
    } else if (parsed is Map) {
      entries = [parsed];
    } else {
      _log('[CRITICAL] Unexpected JSON root type: ${parsed.runtimeType}');
      await phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final failedPhraseIds = <int>[];
    final processedIds = <int>{};

    for (final entry in entries) {
      final outcome = await processPhraseEntryData(entry);
      if (outcome == null) {
        _log('[WARNING] Entry completely malformed, skipped.');
        continue;
      }
      
      processedIds.add(outcome.phraseId);
      if (!outcome.ok) {
        _log('[ERROR] Phrase ${outcome.phraseId} failed during processing.');
        failedPhraseIds.add(outcome.phraseId);
        // Status is already reset inside processPhraseEntryData for failures
      }
    }

    // Detection of missing IDs
    final missingIds = <int>[];
    for (final expectedId in expectedIds) {
      if (!processedIds.contains(expectedId)) {
        _log('[MISSING] Phrase $expectedId was expected but NOT found in AI response.');
        missingIds.add(expectedId);
        failedPhraseIds.add(expectedId);
      }
    }

    if (missingIds.isNotEmpty) {
      _log('Resetting status for ${missingIds.length} missing phrases.');
      await phraseService.resetPhrasesTranslationStatusByIds(missingIds);
    }

    _log('Processed IDs: ${processedIds.toList()}');
    _log('Failed/Missing IDs: $failedPhraseIds');
    _log('--- END PROCESS RESPONSE ---');

    if (failedPhraseIds.isEmpty) {
      return AiRequestResult.success();
    }
    return AiRequestResult.partialSuccess(failedPhraseIds.toList());
  }

  Future<_PhraseOutcome?> processPhraseEntryData(
      dynamic phrasesData, {
        Set<String>? dedupSignatures,
      }) async {
    if (phrasesData == null || phrasesData is! Map) {
      _log('skipped: entry is not a Map');
      return null;
    }

    final int phraseId = ResponseParserUtils.parseId(phrasesData['phraseId']);
    if (phraseId <= 0) {
      _log('skipped: invalid phraseId (${phrasesData['phraseId']})');
      return null;
    }

    _log('>> Processing Phrase $phraseId');

    final rawBlocks = phrasesData['blocks'];
    if (rawBlocks is! List || rawBlocks.isEmpty) {
      _log('[PHRASE $phraseId] No blocks found in JSON.');
      await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
      return _PhraseOutcome(phraseId: phraseId, ok: false);
    }

    final phrase = await phraseService.getPhraseById(phraseId);
    if (phrase == null) {
      _log('[PHRASE $phraseId] Not found in database.');
      return _PhraseOutcome(phraseId: phraseId, ok: false);
    }

    final Set<String> referenceVersionKeys = _normalizer.collectReferenceVersionKeys(rawBlocks);
    final firstWordPos = _normalizer.findFirstWordPosition(rawBlocks);

    bool phraseHadErrors = false;

    for (var block in rawBlocks) {
      try {
        if (block is! Map || !block.containsKey('b_pos') || !block.containsKey('tr')) {
          _log('[PHRASE $phraseId][BLOCK ERR] Missing mandatory fields (b_pos/tr) in block: $block');
          phraseHadErrors = true;
          continue;
        }

        final int? blockPos = block['b_pos'] is int
            ? block['b_pos'] as int
            : int.tryParse(block['b_pos'].toString());
        
        if (blockPos == null) {
          _log('[PHRASE $phraseId][BLOCK ERR] Invalid b_pos: ${block['b_pos']}');
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
          _log('[PHRASE $phraseId][BLOCK] Already exists: $contentSignature');
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
        onProgress();

        final List<dynamic> wordDataJson = block['word'] is List ? block['word'] as List : [];

        for (var wordData in wordDataJson) {
          try {
            if (wordData is! Map) {
              _log('[PHRASE $phraseId][WORD ERR] Non-map word entry in block $blockPos');
              phraseHadErrors = true;
              continue;
            }
            final Map<String, dynamic> map = Map<String, dynamic>.from(wordData);

            final int? currentWordPos = map['w_pos'] is int
                ? map['w_pos'] as int
                : int.tryParse(map['w_pos']?.toString() ?? '');

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
            _log('[PHRASE $phraseId][WORD ERR] Fail to save word: $e');
            phraseHadErrors = true;
          }
        }
      } catch (e) {
        _log('[PHRASE $phraseId][BLOCK ERR] Fail to process block: $e');
        phraseHadErrors = true;
      }
    }

    if (!phraseHadErrors) {
      await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId);
      _log('[PHRASE $phraseId] SUCCESS');
    } else {
      await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
      _log('[PHRASE $phraseId] FAILED during processing, status reset for retry.');
    }

    return _PhraseOutcome(phraseId: phraseId, ok: !phraseHadErrors);
  }

  Future<AiRequestResult> saveTranslationsResponse(Map<String, dynamic> parsedJson, {List<int> expectedIds = const []}) async {
    _log('--- START SAVE TRANSLATIONS ---');
    _log('Expected IDs: $expectedIds');

    final lines = parsedJson['lines'];
    if (lines is! List) {
      _log('[CRITICAL] "lines" is not a List in translation response.');
      await phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final failedPhraseIds = <int>[];
    final processedIds = <int>{};

    for (var lineData in lines) {
      if (lineData is! Map<String, dynamic>) continue;
      
      final int phraseId = ResponseParserUtils.parseId(lineData['id']);
      final String translation = lineData['translation']?.toString() ?? '';

      if (phraseId <= 0 || translation.isEmpty) {
        _log('[WARNING] Invalid translation entry for ID $phraseId');
        if (phraseId > 0) {
          failedPhraseIds.add(phraseId);
          await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
        }
        continue;
      }

      processedIds.add(phraseId);
      try {
        await phraseService.updateTranslatedPhraseText(phraseId, translation);
      } catch (e) {
        _log('[ERROR] Failed to save translation for Phrase $phraseId: $e');
        failedPhraseIds.add(phraseId);
        await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
      }
    }

    final missingIds = <int>[];
    for (final expectedId in expectedIds) {
      if (!processedIds.contains(expectedId)) {
        _log('[MISSING] Translation for $expectedId not found in AI response.');
        missingIds.add(expectedId);
        failedPhraseIds.add(expectedId);
      }
    }

    if (missingIds.isNotEmpty) {
      _log('Resetting status for ${missingIds.length} missing translations.');
      await phraseService.resetPhrasesTranslationStatusByIds(missingIds);
    }

    _log('Processed IDs: ${processedIds.toList()}');
    _log('Failed/Missing IDs: $failedPhraseIds');
    _log('--- END SAVE TRANSLATIONS ---');

    if (failedPhraseIds.isEmpty) {
      return AiRequestResult.success();
    }
    return AiRequestResult.partialSuccess(failedPhraseIds.toList());
  }
}

class _PhraseOutcome {
  final int phraseId;
  final bool ok;
  const _PhraseOutcome({required this.phraseId, required this.ok});
}
