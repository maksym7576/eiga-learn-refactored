
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
    };

    static final DepackerLanguageConfig _default = DepackerLanguageConfig(
        language: 'default',
        removeAllSpaces: false,
    );

    static DepackerLanguageConfig getConfig(String? language) {
      if (language == null) return _default;
      return _configs[language.toLowerCase()] ?? _default;
    }
  }