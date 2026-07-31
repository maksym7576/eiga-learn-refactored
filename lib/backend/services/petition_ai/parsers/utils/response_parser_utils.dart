class ResponseParserUtils {
  static int parseId(dynamic raw) {
    if (raw is int) return raw;
    return int.tryParse(raw.toString()) ?? -1;
  }

  static List<int> parseIntList(dynamic raw) {
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

  static String parseColorHex(dynamic raw) {
    final value = raw?.toString() ?? '';
    final isValidHex = RegExp(r'^#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$').hasMatch(value);
    return isValidHex ? value : '#FFFFFF';
  }
}
