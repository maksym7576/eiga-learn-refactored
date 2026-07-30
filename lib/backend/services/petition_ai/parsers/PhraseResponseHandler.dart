// PhraseResponseHandler.dart
import 'dart:convert';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/services/models_services/blockService.dart';
import 'package:eiga/backend/services/models_services/phraseService.dart';
import 'package:eiga/backend/services/models_services/wordService.dart';
import 'package:eiga/backend/exeption/AiUserFacingError.dart';
import 'package:eiga/backend/exeption/GeminiException.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../../../providers/AiRequestPhase.dart';

typedef _FirstWordPos = ({int blockPos, int wordPos});

class PhraseResponseHandler {
  final PhraseService phraseService;
  final BlockService blockService;
  final WordService wordService;
  final void Function() onProgress;

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
  static const Map<String, String> _jpToLatinPunctuation = {
    '。': '.',
    '、': ',',
    '！': '!',
    '？': '?',
    '…': '...',
    '「': '"',
    '」': '"',
    '『': '"',
    '』': '"',
    '・': '-',
    '〜': '~',
    '：': ':',
    '；': ';',
    '（': '(',
    '）': ')',
  };

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

    final int phraseId = _parseId(phrasesData['phraseId']);
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

    final Set<String> referenceVersionKeys = _collectReferenceVersionKeys(rawBlocks);

    final _FirstWordPos? firstWordPos = _findFirstWordPosition(rawBlocks);

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
          translatedPositionIndex: _parseIntList(block['tr_pos']),
          blockPositionIndex: blockPos,
          contentSignature: contentSignature,
          colorHex: _parseColorHex(block['colorHex']),
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
              ..versions = _normalizeWordVersions(
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
      final int phraseId = _parseId(lineData['id']);
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

  _FirstWordPos? _findFirstWordPosition(List<dynamic> blocks) {
    int? minBlockPos;
    int? minWordPosInMinBlock;

    for (final block in blocks) {
      if (block is! Map) continue;
      final bPosRaw = block['b_pos'];
      final bPos = bPosRaw is int ? bPosRaw : int.tryParse(bPosRaw.toString());
      if (bPos == null) continue;

      final words = block['word'];
      if (words is! List || words.isEmpty) continue;

      if (minBlockPos == null || bPos < minBlockPos) {
        minBlockPos = bPos;
        minWordPosInMinBlock = null;
      }

      if (bPos == minBlockPos) {
        for (final wordData in words) {
          if (wordData is! Map) continue;
          final wPosRaw = wordData['w_pos'];
          final wPos = wPosRaw is int ? wPosRaw : int.tryParse(wPosRaw?.toString() ?? '');
          if (wPos == null) continue;
          if (minWordPosInMinBlock == null || wPos < minWordPosInMinBlock) {
            minWordPosInMinBlock = wPos;
          }
        }
      }
    }

    if (minBlockPos == null || minWordPosInMinBlock == null) return null;
    return (blockPos: minBlockPos, wordPos: minWordPosInMinBlock);
  }


  Set<String> _collectReferenceVersionKeys(List<dynamic> blocks) {
    final Set<String> keys = {};
    for (var block in blocks) {
      if (block is! Map) continue;
      final words = block['word'];
      if (words is! List) continue;
      for (var wordData in words) {
        if (wordData is! Map) continue;
        for (var entry in wordData.entries) {
          if (entry.key == 'w_pos') continue;
          if (entry.value == null || entry.value.toString().isEmpty) continue;
          final key = entry.key.toString() == 'romanji' ? 'romaji' : entry.key.toString();
          keys.add(key);
        }
      }
    }
    return keys;
  }

  List<ReadingItem> _normalizeWordVersions(
      Map<String, dynamic> map,
      Set<String> referenceVersionKeys, {
        bool isFirstWordInPhrase = false,
      }) {
    final presentEntries = map.entries
        .where((e) => e.key != 'w_pos')
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .toList();

    final Map<String, String> versionsByKey = {
      for (var e in presentEntries)
        (e.key.toString() == 'romanji' ? 'romaji' : e.key.toString()): e.value.toString(),
    };

    if (versionsByKey.isEmpty) {
      _log('Handler -> word has no readable versions, skipped normalization');
      return [];
    }

    final bool romajiWasPresentInInput = presentEntries.any(
          (e) => (e.key.toString() == 'romanji' ? 'romaji' : e.key.toString()) == 'romaji',
    );

    if (referenceVersionKeys.isEmpty || versionsByKey.length == referenceVersionKeys.length) {
    } else if (versionsByKey.length == 1) {
      final soleValue = versionsByKey.values.first;
      for (final key in referenceVersionKeys) {
        versionsByKey.putIfAbsent(key, () => soleValue);
      }
    } else if (versionsByKey.length < referenceVersionKeys.length) {
      final missing = referenceVersionKeys.difference(versionsByKey.keys.toSet());
      final fallbackValue = versionsByKey.values.first;
      for (final key in missing) {
        versionsByKey[key] = fallbackValue;
      }
      _log(
        'Handler -> word had partial versions, filled missing [${missing.join(", ")}] '
            'with fallback value (present: ${versionsByKey.keys.join(", ")})',
      );
    } else {
      _log(
        'Handler -> word has more version keys than reference set '
            '(${versionsByKey.keys.join(", ")} vs ${referenceVersionKeys.join(", ")})',
      );
    }

    final bool romajiWasFilledByFallback = !romajiWasPresentInInput && versionsByKey.containsKey('romaji');
    if (romajiWasFilledByFallback) {
      versionsByKey['romaji'] = _normalizeRomajiPunctuation(versionsByKey['romaji']!);
    }

    // Капіталізація першої літери — лише для найпершого слова речення (фрази).
    if (isFirstWordInPhrase && versionsByKey.containsKey('romaji')) {
      versionsByKey['romaji'] = _capitalizeFirst(versionsByKey['romaji']!);
    }

    return versionsByKey.entries.map((e) => ReadingItem(key: e.key, text: e.value)).toList();
  }

  // ---------------------------------------------------------------------
  // Текстові хелпери (romaji)
  // ---------------------------------------------------------------------

  String _normalizeRomajiPunctuation(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_jpToLatinPunctuation[char] ?? char);
    }
    return buffer.toString();
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }


  int _parseId(dynamic raw) {
    if (raw is int) return raw;
    return int.tryParse(raw.toString()) ?? -1;
  }

  List<int> _parseIntList(dynamic raw) {
    if (raw is! List) return [];
    final result = <int>[];
    for (final item in raw) {
      if (item is int) {
        result.add(item);
      } else {
        final parsed = int.tryParse(item.toString());
        if (parsed != null) result.add(parsed);
      }
    }
    return result.toSet().toList();
  }

  String _parseColorHex(dynamic raw) {
    final value = raw?.toString() ?? '';
    final isValidHex = RegExp(r'^#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$').hasMatch(value);
    return isValidHex ? value : '#FFFFFF';
  }
}

class _PhraseOutcome {
  final int phraseId;
  final bool ok;
  const _PhraseOutcome({required this.phraseId, required this.ok});
}