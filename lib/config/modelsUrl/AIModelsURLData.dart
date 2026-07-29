enum AiProvider { google, openai, anthropic, custom }

enum ModelQuality { basic, standard, high, frontier }
enum ModelSpeed { ultraFast, fast, medium, slow }
enum InputType { text, image, audio, video, pdf }

class AiModelEntry {
  final AiProvider provider;
  final String name;
  final String url;
  final int defaultLimit;
  final int defaultPhrasesPerRequest;

  final bool supportsWebSearch;

  final bool supportsStreaming;
  final bool supportsLiveApi;

  final ModelQuality quality;
  final bool supportsThinking;

  final ModelSpeed speed;
  final int estimatedTokensPerSec;

  final int contextWindow;
  final int maxOutputTokens;
  final List<InputType> supportedInputs;
  final double inputPricePerMToken;
  final double outputPricePerMToken;

  const AiModelEntry({
    required this.provider,
    required this.name,
    required this.url,
    required this.defaultLimit,
    required this.defaultPhrasesPerRequest,
    this.supportsWebSearch = false,
    this.supportsStreaming = true,
    this.supportsLiveApi = false,
    required this.quality,
    this.supportsThinking = false,
    required this.speed,
    this.estimatedTokensPerSec = 50,
    required this.contextWindow,
    required this.maxOutputTokens,
    this.supportedInputs = const [InputType.text],
    this.inputPricePerMToken = 0.0,
    this.outputPricePerMToken = 0.0,
  });
}

final List<AiModelEntry> aiModels = [
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemini-2.5-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: true,
    supportsStreaming: true,
    supportsLiveApi: false,
    quality: ModelQuality.basic,
    speed: ModelSpeed.ultraFast,
    estimatedTokensPerSec: 150,
    contextWindow: 1000000,
    maxOutputTokens: 8192,
    supportedInputs: [InputType.text, InputType.image],
    inputPricePerMToken: 0.075,
    outputPricePerMToken: 0.30,
  ),
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemini-2.5-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: true,
    supportsStreaming: true,
    supportsLiveApi: true,
    quality: ModelQuality.standard,
    speed: ModelSpeed.fast,
    estimatedTokensPerSec: 100,
    contextWindow: 1000000,
    maxOutputTokens: 8192,
    supportedInputs: [InputType.text, InputType.image, InputType.audio, InputType.video, InputType.pdf],
    inputPricePerMToken: 0.15,
    outputPricePerMToken: 0.60,
  ),
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemini-3-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: true,
    supportsStreaming: true,
    supportsLiveApi: true,
    quality: ModelQuality.standard,
    speed: ModelSpeed.fast,
    estimatedTokensPerSec: 110,
    contextWindow: 1000000,
    maxOutputTokens: 8192,
    supportedInputs: [InputType.text, InputType.image, InputType.audio, InputType.video, InputType.pdf],
    inputPricePerMToken: 0.15,
    outputPricePerMToken: 0.60,
  ),
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemini-3.1-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite',
    defaultLimit: 500,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: true,
    supportsStreaming: true,
    supportsLiveApi: false,
    quality: ModelQuality.basic,
    speed: ModelSpeed.ultraFast,
    estimatedTokensPerSec: 180,
    contextWindow: 1000000,
    maxOutputTokens: 8192,
    supportedInputs: [InputType.text, InputType.image],
    inputPricePerMToken: 0.07,
    outputPricePerMToken: 0.25,
  ),
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemini-3.5-flash-lite',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite',
    defaultLimit: 500,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: true,
    supportsStreaming: true,
    supportsLiveApi: false,
    quality: ModelQuality.basic,
    speed: ModelSpeed.ultraFast,
    estimatedTokensPerSec: 200,
    contextWindow: 2000000,
    maxOutputTokens: 8192,
    supportedInputs: [InputType.text, InputType.image],
    inputPricePerMToken: 0.05,
    outputPricePerMToken: 0.20,
  ),
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemini-3.5-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: true,
    supportsStreaming: true,
    supportsLiveApi: true,
    quality: ModelQuality.high,
    speed: ModelSpeed.fast,
    estimatedTokensPerSec: 120,
    contextWindow: 2000000,
    maxOutputTokens: 16384,
    supportedInputs: [InputType.text, InputType.image, InputType.audio, InputType.video, InputType.pdf],
    inputPricePerMToken: 0.10,
    outputPricePerMToken: 0.40,
  ),
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemini-3.6-flash',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash',
    defaultLimit: 20,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: true,
    supportsStreaming: true,
    supportsLiveApi: true,
    quality: ModelQuality.high,
    speed: ModelSpeed.fast,
    estimatedTokensPerSec: 130,
    contextWindow: 2000000,
    maxOutputTokens: 16384,
    supportedInputs: [InputType.text, InputType.image, InputType.audio, InputType.video, InputType.pdf],
    inputPricePerMToken: 0.10,
    outputPricePerMToken: 0.40,
  ),
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemma-4-26b',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemma-4-26b',
    defaultLimit: 14400,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: false,
    supportsStreaming: true,
    supportsLiveApi: false,
    quality: ModelQuality.standard,
    speed: ModelSpeed.medium,
    estimatedTokensPerSec: 60,
    contextWindow: 128000,
    maxOutputTokens: 8192,
    supportedInputs: [InputType.text],
    inputPricePerMToken: 0.0,
    outputPricePerMToken: 0.0,
  ),
  AiModelEntry(
    provider: AiProvider.google,
    name: 'gemma-4-31b',
    url: 'https://generativelanguage.googleapis.com/v1beta/models/gemma-4-31b',
    defaultLimit: 14400,
    defaultPhrasesPerRequest: 10,
    supportsWebSearch: false,
    supportsStreaming: true,
    supportsLiveApi: false,
    quality: ModelQuality.high,
    supportsThinking: true,
    speed: ModelSpeed.medium,
    estimatedTokensPerSec: 45,
    contextWindow: 128000,
    maxOutputTokens: 8192,
    supportedInputs: [InputType.text],
    inputPricePerMToken: 0.0,
    outputPricePerMToken: 0.0,
  ),
];