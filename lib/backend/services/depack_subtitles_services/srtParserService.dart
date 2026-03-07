


import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/config/depacker/depackerLanguageConfig.dart';

class SrtParser {
  final DepackerLanguageConfig config;

  SrtParser(this.config);

  List<PhraseObject> parse(String content, int videoId) {
    final phrases = <PhraseObject>[];
    int order = 1;
    
    final blocks = content
    .trim()
    .split(RegExp(r'\r?\n\s*\r?\n'))
    .map((b) => b.trim())
    .where((b) => b.isNotEmpty);
    
    for (final block in blocks) {
      final phrase = _parseBlock(block, videoId, order);
      if (phrase != null) {
        phrases.add(phrase);
        order++;
      }
    }

    return phrases;
  }

  PhraseObject? _parseBlock(String block, int videoId, int order) {
    if (block.contains('in][native]') || block.contains('~MyPlayer()')) return null;

    final lines = block
    .split(RegExp(r'\r?\n'))
    .map((l) => l.trim())
    .where((l) => l.isNotEmpty)
    .toList();

    if (lines.isEmpty) return null;

    final timeLineIndex = int.tryParse(lines[0]) != null ? 1 : 0;
    if (lines.length <= timeLineIndex) return null;

    final times = lines[timeLineIndex].split(RegExp(r'\s*-->\s*'));
    if (times.length != 2) return null;

    final textLines = lines.sublist(timeLineIndex + 1);
    if (textLines.isEmpty) return null;

    return PhraseObject(
      videoId: videoId,
      phraseOrder: order,
      originalPhrase: _processText(textLines.join(' ')),
      startTime: _parseTime(times[0]),
      endTime: _parseTime(times[1]),
    );
  }

  String _processText(String text) {
    if (config.removeAllSpaces) return text.replaceAll(RegExp(r'\s+'), '');
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  
  DateTime _parseTime(String raw) {
    final m = RegExp(r'(\d{1,2}):(\d{2}):(\d{2})[,.](\d{1,3})').firstMatch(raw.trim());
    if (m == null) return DateTime(1970);

    var ms = m.group(4)!;
    if (ms.length == 1) ms = '${ms}00';
    else if (ms.length == 2) ms = '${ms}0';

    return DateTime(1970, 1, 1,
        int.parse(m.group(1)!),
        int.parse(m.group(2)!),
        int.parse(m.group(3)!),
        int.parse(ms),
    );
  }
}