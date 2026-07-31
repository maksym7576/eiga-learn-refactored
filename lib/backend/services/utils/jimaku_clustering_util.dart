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
    // Remove common episode indicators like "E01", "Ep 01", " - 01", " _ 01", " [01]"
    // Also remove file extension
    String base = name;
    
    // Remove extension
    if (base.contains('.')) {
      base = base.substring(0, base.lastIndexOf('.'));
    }

    // Regexp for episode numbers, often preceded by space, dash, or bracket
    // Matches things like " 01", " - 01", " Ep.01", " [01]"
    final epRegex = RegExp(r'([\s\-_\[(]+)(?:[Ee][Pp][.\s]*)?(\d+)([\s\-_\])]*)');
    
    final match = epRegex.firstMatch(base);
    if (match != null) {
      // Take everything before the first episode-like number
      return base.substring(0, match.start).trim();
    }

    return base.trim();
  }
}
