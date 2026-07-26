import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/config/modelsUrl/aiModelManager.dart';
import 'package:eiga/config/prompts/promptManager.dart';
import 'package:eiga/config/secureStorage.dart';
import 'package:eiga/providers/AIRequestStatusProvider.dart';

import '../exeption/geminiException.dart';
import 'petition_ai/gemini/GeminiHTTPService.dart';
import 'petition_ai/gemini/geminiStreamingService.dart';

const String TRANSPORT_STREAM = 'stream';
const String TRANSPORT_HTTP = 'http';

final defaultAiTransportProvider = StateProvider<String>((ref) => TRANSPORT_STREAM);

class AiService {
  final GeminiHTTPService geminiHTTPService;
  final GeminiStreamingService geminiStreamingService;
  final AiRequestNotifier aiRequestNotifier;

  AiService({
    required this.geminiHTTPService,
    required this.geminiStreamingService,
    required this.aiRequestNotifier,
  });

  Future<String> _formToken({required bool isStreaming}) async {
    final aiModelManager = AiModelManager();
    final model = await aiModelManager.getCurrentModel();

    final String endpoint = isStreaming ? ':streamGenerateContent' : ':generateContent';
    final String fullUrl = '${model.url}$endpoint';
    final token = await SecureTokenStorage.getToken(ApiTokenType.gemeni);

    if (token == null || token.isEmpty) {
      throw Exception('AI token is not set');
    }

    return '$fullUrl?key=$token';
  }

  Future<String> _formPrompt(
      List<PhraseObject> phraseObjectsList,
      String originalLanguage,
      String translationLanguage,
      ) async {
    final String prompt = PromptManager.getPromptByLanguage(
      originalLanguage,
      translationLanguage,
    );

    final sortPhraseList = List<PhraseObject>.from(phraseObjectsList)
      ..sort((a, b) => (a.phraseOrder ?? 0).compareTo(b.phraseOrder ?? 0));

    final simplifiedPhrasesList = sortPhraseList
        .map((phrase) => {'id': phrase.id, 'text': phrase.originalPhrase ?? ''})
        .toList();

    final String jsonData = jsonEncode(simplifiedPhrasesList);

    return '''
$prompt
INPUT DATA (JSON Format):
$jsonData
''';
  }

  Future<void> translatePhraseList({
    required List<PhraseObject> phraseObjectsList,
    required String originalLanguage,
    required String translationLanguage,
    String? transportName,
  }) async {
    int attempts = 0;
    const int maxRetries = 1;

    final aiModelManager = AiModelManager();
    final model = await aiModelManager.getCurrentModel();

    final resolvedTransport = transportName ?? TRANSPORT_STREAM;
    final bool isStreamingMode = resolvedTransport == TRANSPORT_STREAM;

    aiRequestNotifier.start(
      processingMethod: isStreamingMode ? AiProcessingMethod.streaming : AiProcessingMethod.fullResponse,
      modelName: model.name,
      itemsTotal: phraseObjectsList.length,
    );

    try {
      while (true) {
        try {
          attempts++;
          aiRequestNotifier.setRetry(attempts - 1);
          aiRequestNotifier.setSending();

          final String fullUrl = await _formToken(isStreaming: isStreamingMode);
          final String promptWithPhrases = await _formPrompt(
            phraseObjectsList,
            originalLanguage,
            translationLanguage,
          );

          if (model.name.toLowerCase().contains('gemini') || model.name.toLowerCase().contains('gemma')) {
            if (isStreamingMode) {
              aiRequestNotifier.setStreamingResponse();
              await geminiStreamingService.sendStreamAndParseRequest(fullUrl, promptWithPhrases);
            } else {
              aiRequestNotifier.setWaitingResponse();
              await geminiHTTPService.sendAndParseRequest(fullUrl, promptWithPhrases);
            }
          } else {
            throw Exception("Model type ${model.name} is not supported yet");
          }

          aiRequestNotifier.success();
          break;
        } catch (error, stackTrace) {
          if (error is GeminiGeneralException ||
              error is GeminiModelExpiredException ||
              error is GeminiIncorrectTokenException) {
            aiRequestNotifier.reportError(
              error,
              message: error.toString(),
              stackTrace: stackTrace,
              terminal: true,
            );
            rethrow;
          }

          bool isRetryable = error is GeminiServerException || error is Exception;

          aiRequestNotifier.reportError(
            error,
            message: error.toString(),
            stackTrace: stackTrace,
            terminal: !isRetryable,
          );

          if (isRetryable && attempts <= maxRetries) {
            await Future.delayed(const Duration(seconds: 2));
            continue;
          } else {
            rethrow;
          }
        }
      }
    } finally {
      await aiModelManager.incrementUsage(model.name);
    }
  }
}