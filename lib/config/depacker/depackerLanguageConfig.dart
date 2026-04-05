
class DepackerLanguageConfig {
  final String language;
  final bool removeAllSpaces;

  const DepackerLanguageConfig({
    required this.language,
    this.removeAllSpaces = false,
  });
}

  class DepackerLanguageConfigRegistry {
    static final Map<String, DepackerLanguageConfig> _configs = {
      'japanese': DepackerLanguageConfig(
        language: 'japanese',
        removeAllSpaces: true,
      ),
      'english': const DepackerLanguageConfig(
        language: 'english',
      ),
      'spanish': const DepackerLanguageConfig(
        language: 'spanish',
      ),
      'ukrainian': const DepackerLanguageConfig(
        language: 'ukrainian',
      ),
      'russian': const DepackerLanguageConfig(
        language: 'russian',
      ),
      'german': const DepackerLanguageConfig(
        language: 'german',
      ),
      'french': const DepackerLanguageConfig(
        language: 'french',
      ),
      'italian': const DepackerLanguageConfig(
        language: 'italian',
      ),
      'chinese': const DepackerLanguageConfig(
        language: 'chinese',
        removeAllSpaces: true,
      ),
      'korean': const DepackerLanguageConfig(
        language: 'korean',
        removeAllSpaces: true,
      ),
    };

    static final DepackerLanguageConfig _default = DepackerLanguageConfig(
        language: 'default',
        removeAllSpaces: false,
    );

    static DepackerLanguageConfig getConfig(String? language) {
      if (language == null) return _default;
      return _configs[language.toLowerCase()] ?? _default;
    }

    static List<String> getAllLanguages() {
      return _configs.keys.toList();
    }

  }