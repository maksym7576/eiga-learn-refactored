import 'package:eiga/providers/readingTypeProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReadingTypeLanguageConfig {
  final String language;
  final List<String> options;

  const ReadingTypeLanguageConfig({
    required this.language,
    required this.options,
  });
}

class ReadingTypeLanguageConfigRegistry {
  static final Map<String, ReadingTypeLanguageConfig> _confing = {
    'japanese': ReadingTypeLanguageConfig (
      language: 'japanese',
      options: ['original', 'kana', 'romanji'],
    ),
  };

  static final ReadingTypeLanguageConfig _default = ReadingTypeLanguageConfig(
      language: 'default',
      options: ['original'],
  );

  static ReadingTypeLanguageConfig getConfing(String? language) {
    if (language == null) return _default;
    return _confing[language.toLowerCase()] ?? _default;
  }

  static List<String> getAllLanguages() {
    return _confing.keys.toList();
  }
}

final readingTypeNotifierProvider = AsyncNotifierProvider.autoDispose<ReadingTypeNotifier, ReadingTypeProvider>(
  ReadingTypeNotifier.new,
);