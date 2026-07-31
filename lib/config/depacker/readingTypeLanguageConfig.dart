import 'package:eiga/providers/readingTypeProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReadingTypeLanguageConfig {
  final String language;
  final List<String> options;
  final List<String> spacingOptions;

  const ReadingTypeLanguageConfig({
    required this.language,
    required this.options,
    this.spacingOptions = const [],
  });
}

class ReadingTypeLanguageConfigRegistry {
  static final Map<String, ReadingTypeLanguageConfig> _confing = {
    'japanese': ReadingTypeLanguageConfig (
      language: 'japanese',
      options: ['original', 'kana', 'romaji'],
      spacingOptions: ['romaji'],
    ),
    'english': ReadingTypeLanguageConfig(
      language: 'english',
      options: ['original'],
      spacingOptions: ['original'],
    ),
  };

  static final ReadingTypeLanguageConfig _default = ReadingTypeLanguageConfig(
      language: 'default',
      options: ['original'],
      spacingOptions: ['original'],
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