class AiModelSettingsDTO {
  final String name;
  final String url;

  // --- Ліміт (загальний) ---
  final int currentMaxLimit;
  final int defaultMaxLimit;
  final bool isMaxLimitCustom;
  final int used;

  // --- Ліміт (денний) ---
  final int currentDailyMaxLimit;
  final int defaultDailyMaxLimit;
  final bool isDailyMaxLimitCustom;
  final int dailyUsed;

  // --- Фраз на запит ---
  final int currentPhrasesPerRequest;
  final int defaultPhrasesPerRequest;
  final bool isPhrasesPerRequestCustom;

  // --- Стрімінг ---
  final bool currentStreamingEnabled;
  final bool defaultStreamingEnabled;
  final bool isStreamingCustom;

  final DateTime? lastUpdated;

  const AiModelSettingsDTO({
    required this.name,
    required this.url,
    required this.currentMaxLimit,
    required this.defaultMaxLimit,
    required this.isMaxLimitCustom,
    required this.used,
    required this.currentDailyMaxLimit,
    required this.defaultDailyMaxLimit,
    required this.isDailyMaxLimitCustom,
    required this.dailyUsed,
    required this.currentPhrasesPerRequest,
    required this.defaultPhrasesPerRequest,
    required this.isPhrasesPerRequestCustom,
    required this.currentStreamingEnabled,
    required this.defaultStreamingEnabled,
    required this.isStreamingCustom,
    this.lastUpdated,
  });

  get usageColor {
    final ratio = used / currentMaxLimit;
    if (ratio > 0.9) return 0xFFEF4444; // Red 500
    if (ratio > 0.7) return 0xFFF59E0B; // Amber 500
    return 0xFF10B981; // Emerald 500
  }

  AiModelSettingsDTO copyWith({
    String? name,
    String? url,
    int? currentMaxLimit,
    int? defaultMaxLimit,
    bool? isMaxLimitCustom,
    int? used,
    int? currentDailyMaxLimit,
    int? defaultDailyMaxLimit,
    bool? isDailyMaxLimitCustom,
    int? dailyUsed,
    int? currentPhrasesPerRequest,
    int? defaultPhrasesPerRequest,
    bool? isPhrasesPerRequestCustom,
    bool? currentStreamingEnabled,
    bool? defaultStreamingEnabled,
    bool? isStreamingCustom,
    DateTime? lastUpdated,
  }) {
    return AiModelSettingsDTO(
      name: name ?? this.name,
      url: url ?? this.url,
      currentMaxLimit: currentMaxLimit ?? this.currentMaxLimit,
      defaultMaxLimit: defaultMaxLimit ?? this.defaultMaxLimit,
      isMaxLimitCustom: isMaxLimitCustom ?? this.isMaxLimitCustom,
      used: used ?? this.used,
      currentDailyMaxLimit: currentDailyMaxLimit ?? this.currentDailyMaxLimit,
      defaultDailyMaxLimit: defaultDailyMaxLimit ?? this.defaultDailyMaxLimit,
      isDailyMaxLimitCustom: isDailyMaxLimitCustom ?? this.isDailyMaxLimitCustom,
      dailyUsed: dailyUsed ?? this.dailyUsed,
      currentPhrasesPerRequest: currentPhrasesPerRequest ?? this.currentPhrasesPerRequest,
      defaultPhrasesPerRequest: defaultPhrasesPerRequest ?? this.defaultPhrasesPerRequest,
      isPhrasesPerRequestCustom: isPhrasesPerRequestCustom ?? this.isPhrasesPerRequestCustom,
      currentStreamingEnabled: currentStreamingEnabled ?? this.currentStreamingEnabled,
      defaultStreamingEnabled: defaultStreamingEnabled ?? this.defaultStreamingEnabled,
      isStreamingCustom: isStreamingCustom ?? this.isStreamingCustom,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

}