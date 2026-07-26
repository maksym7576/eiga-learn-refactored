import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/config/depacker/depackerLanguageConfig.dart';

class AssParser {
  final DepackerLanguageConfig config;

  static const _skipStyles = {'Title', 'Screen', 'AN7', 'Dial-CNI'};

  AssParser(this.config);

  List<PhraseObject> parse(String content, int videoId) {
    final phrases = <PhraseObject>[];
    int order = 1;

    final lines = content
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.startsWith('Dialogue:'))
        .toList();

    _DialogueGroup? group;

    for (final line in lines) {
      final raw = _parseDialogueLine(line);
      if (raw == null || _skipStyles.contains(raw.style)) continue;

      if (group != null &&
          group.start == raw.start &&
          group.end == raw.end &&
          group.style == raw.style) {
        group.texts.add(raw.text);
        continue;
      }

      if (group != null) {
        final phrase = _toPhrase(group, videoId, order);
        if (phrase != null) {
          phrases.add(phrase);
          order++;
        }
      }
      group = _DialogueGroup(raw.style, raw.start, raw.end, [raw.text]);
    }

    if (group != null) {
      final phrase = _toPhrase(group, videoId, order);
      if (phrase != null) phrases.add(phrase);
    }

    return phrases;
  }

  _RawDialogue? _parseDialogueLine(String line) {
    final data = line.substring(9).trim();
    final parts = data.split(',');
    if (parts.length < 10) return null;

    final style = parts[3].trim();
    final startRaw = parts[1].trim();
    final endRaw = parts[2].trim();
    final rawText = parts.sublist(9).join(',');

    var cleanText = rawText.replaceAll(RegExp(r'\{[^}]*\}'), '');
    cleanText = cleanText.replaceAll(RegExp(r'\\[Nn]'), ' ').trim();
    if (cleanText.isEmpty) return null;

    return _RawDialogue(style, startRaw, endRaw, cleanText);
  }

  PhraseObject? _toPhrase(_DialogueGroup group, int videoId, int order) {
    final text = _processText(group.texts.join(' '));
    if (text.isEmpty) return null;

    return PhraseObject(
      videoId: videoId,
      phraseOrder: order,
      originalPhrase: text,
      startTime: _parseTime(group.start),
      endTime: _parseTime(group.end),
    );
  }

  String _processText(String text) {
    if (config.removeAllSpaces) return text.replaceAll(RegExp(r'\s+'), '');
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  DateTime _parseTime(String raw) {
    final m = RegExp(r'(\d+):(\d{2}):(\d{2})\.(\d+)').firstMatch(raw.trim());
    if (m == null) return DateTime(1970);

    var msStr = m.group(4)!;
    int ms;

    if (msStr.length == 2) {
      ms = int.parse(msStr) * 10;
    } else if (msStr.length == 1) {
      ms = int.parse(msStr) * 100;
    } else {
      ms = int.parse(msStr.substring(0, 3));
    }

    return DateTime(
      1970, 1, 1,
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
      ms,
    );
  }
}

class _RawDialogue {
  final String style;
  final String start;
  final String end;
  final String text;

  _RawDialogue(this.style, this.start, this.end, this.text);
}

class _DialogueGroup {
  final String style;
  final String start;
  final String end;
  final List<String> texts;

  _DialogueGroup(this.style, this.start, this.end, this.texts);
}