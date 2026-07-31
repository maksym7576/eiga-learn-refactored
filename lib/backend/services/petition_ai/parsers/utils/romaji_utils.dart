class RomajiUtils {
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

  static String normalizePunctuation(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_jpToLatinPunctuation[char] ?? char);
    }
    return buffer.toString();
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static bool isOpeningPunctuation(String text) {
    if (text.isEmpty) return false;
    final first = text[0];
    return '([{<"\''.contains(first);
  }

  static bool isClosingPunctuation(String text) {
    if (text.isEmpty) return false;
    final last = text[text.length - 1];
    return '.,!?;:)]}>"\''.contains(last);
  }

  static bool isNeutralPunctuation(String text) {
    if (text.isEmpty) return false;
    return text.trim() == '"' || text.trim() == "'";
  }
}
