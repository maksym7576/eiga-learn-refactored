class AiModelEntry {
  final String name;
  final String url;
  final int defaultLimit;
  final int defaultPhrasesPerRequest;

  const AiModelEntry({
    required this.name,
    required this.url,
    required this.defaultLimit,
    required this.defaultPhrasesPerRequest,
  });
}

final List<AiModelEntry> aiModels = [
  AiModelEntry(
    name: 'gemini-2.5-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
  ),
  AiModelEntry(
    name: 'gemini-2.5-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
  ),
  AiModelEntry(
    name: 'gemini-3-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
  ),
  AiModelEntry(
    name: 'gemini-3.1-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite',
    defaultLimit: 500,
    defaultPhrasesPerRequest: 10,
  ),
  AiModelEntry(
    name: 'gemini-3.5-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite',
    defaultLimit: 500,
    defaultPhrasesPerRequest: 10,
  ),
  AiModelEntry(
    name: 'gemini-3.5-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
  ),
  AiModelEntry(
    name: 'gemini-3.6-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
  ),
  AiModelEntry(
    name: 'gemma-4-26b',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemma-4-26b',
    defaultLimit: 14400,
    defaultPhrasesPerRequest: 10,
  ),
  AiModelEntry(
    name: 'gemma-4-31b',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemma-4-31b',
    defaultLimit: 14400,
    defaultPhrasesPerRequest: 10,
  ),
];