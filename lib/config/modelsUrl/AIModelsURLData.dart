class AiModelEntry {
  final String name;
  final String url;
  final int defaultLimit;

  const AiModelEntry({
    required this.name,
    required this.url,
    required this.defaultLimit,
  });
}

final List<AiModelEntry> aiModels = [
  // --- Моделі серії Gemini 2.5 ---
  AiModelEntry(
    name: 'gemini-2.5-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite',
    defaultLimit: 20, // RPD: 20
  ),
  AiModelEntry(
    name: 'gemini-2.5-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash',
    defaultLimit: 20, // RPD: 20
  ),

  // --- Моделі серії Gemini 3 / 3.1 ---
  AiModelEntry(
    name: 'gemini-3-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash',
    defaultLimit: 20, // RPD: 20
  ),
  AiModelEntry(
    name: 'gemini-3.1-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite',
    defaultLimit: 500, // RPD: 500
  ),

  // --- Моделі серії Gemini 3.5 / 3.6 ---
  AiModelEntry(
    name: 'gemini-3.5-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite',
    defaultLimit: 500, // RPD: 500
  ),
  AiModelEntry(
    name: 'gemini-3.5-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash',
    defaultLimit: 20, // RPD: 20
  ),
  AiModelEntry(
    name: 'gemini-3.6-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash',
    defaultLimit: 20, // RPD: 20
  ),

  // --- Відкриті моделі Gemma 4 ---
  AiModelEntry(
    name: 'gemma-4-26b',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemma-4-26b',
    defaultLimit: 14400, // RPD: 14.4K
  ),
  AiModelEntry(
    name: 'gemma-4-31b',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemma-4-31b',
    defaultLimit: 14400, // RPD: 14.4K
  ),
];