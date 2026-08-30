import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';

class JimakuGroup {
  final String name;
  final List<FileJimakuDTO> files;
  bool isExpanded;

  JimakuGroup({
    required this.name,
    required this.files,
    this.isExpanded = false,
  });
}

class JimakuClusteringUtil {
  /// Groups files by similar names (common prefixes before episode/version indicators).
  static List<JimakuGroup> groupFiles(List<FileJimakuDTO> files) {
    if (files.length < 10) {
      // Don't group if there are few files, just return one group or individual ones.
      // For consistency, we return them as individual "single-file" groups or one group.
      // But let's try to group anyway if they match.
    }

    final Map<String, List<FileJimakuDTO>> clusters = {};

    for (var file in files) {
      final String baseName = _extractBaseName(file.name);
      clusters.putIfAbsent(baseName, () => []).add(file);
    }

    final List<JimakuGroup> result = [];
    clusters.forEach((name, clusterFiles) {
      // Sort files within the group by name (usually naturally sorts episodes)
      clusterFiles.sort((a, b) => a.name.compareTo(b.name));
      result.add(JimakuGroup(name: name, files: clusterFiles));
    });

    // Sort groups by name
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  static String _extractBaseName(String name) {
    // Remove extension
    String base = name;
    if (base.contains('.')) {
      final lastDot = base.lastIndexOf('.');
      // Check if it's a common extension (3-4 chars)
      final ext = base.substring(lastDot + 1).toLowerCase();
      if (ext == 'ass' || ext == 'srt' || ext == 'zip' || ext == 'rar' || ext == '7z') {
        base = base.substring(0, lastDot);
      }
    }

    // Regexp for episode numbers and season markers
    // 1. Matches "S01E01", "s1e1", "E01", "ep1" etc.
    // 2. Matches " - 01", " _ 01", " . 01"
    // 3. Matches " 01 ", " [01]"
    final epRegex = RegExp(
      r'([\s\-_.]+|\[|\()?'      // Separator or opening bracket
      r'(?:[Ss]\d+[Ee]|[Ee][Pp][.\s]*)?' // Optional "S01E" or "Ep"
      r'(\d+)'                   // The actual episode number
      r'([\s\-_.]+|\]|\))?',    // Trailing separator or closing bracket
      caseSensitive: false,
    );
    
    final match = epRegex.firstMatch(base);
    if (match != null) {
      // Take everything before the first episode-like number
      final prefix = base.substring(0, match.start).trim();
      if (prefix.isNotEmpty) {
        // Clean up trailing dots/dashes
        return prefix.replaceAll(RegExp(r'[\s\-_.]+$'), '');
      }
    }

    return base.trim();
  }
}
