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
  AiModelEntry(
    name: 'gemini-2.5-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite',
    defaultLimit: 15,
  ),
  AiModelEntry(
    name: 'gemini-2.0-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite',
    defaultLimit: 20,
  ),
  AiModelEntry(
    name: 'gemini-2.5-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash',
    defaultLimit: 50,
  ),
  AiModelEntry(
    name: 'gemma-4-31b-it',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemma-4-31b-it',
    defaultLimit: 50,
  ),
];