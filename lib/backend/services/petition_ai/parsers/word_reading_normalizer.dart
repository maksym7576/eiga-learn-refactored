import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'utils/romaji_utils.dart';

typedef _FirstWordPos = ({int blockPos, int wordPos});

class WordReadingNormalizer {
  void _log(String message) {
    assert(() {
      debugPrint('[WordReadingNormalizer] $message');
      return true;
    }());
  }

  _FirstWordPos? findFirstWordPosition(List<dynamic> blocks) {
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

  Set<String> collectReferenceVersionKeys(List<dynamic> blocks) {
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

  List<ReadingItem> normalizeWordVersions(
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
      _log('word has no readable versions, skipped normalization');
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
        'word had partial versions, filled missing [${missing.join(", ")}] '
            'with fallback value (present: ${versionsByKey.keys.join(", ")})',
      );
    } else {
      _log(
        'word has more version keys than reference set '
            '(${versionsByKey.keys.join(", ")} vs ${referenceVersionKeys.join(", ")})',
      );
    }

    final bool romajiWasFilledByFallback = !romajiWasPresentInInput && versionsByKey.containsKey('romaji');
    if (romajiWasFilledByFallback) {
      versionsByKey['romaji'] = RomajiUtils.normalizePunctuation(versionsByKey['romaji']!);
    }

    if (isFirstWordInPhrase && versionsByKey.containsKey('romaji')) {
      versionsByKey['romaji'] = RomajiUtils.capitalizeFirst(versionsByKey['romaji']!);
    }

    return versionsByKey.entries.map((e) => ReadingItem(key: e.key, text: e.value)).toList();
  }
}
