import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/AIRequestStatusProvider.dart';

import '../../config/pipeline/translationPeplines/PipelineManager.dart';
import '../../config/pipeline/translationPeplines/PipelineStepType.dart';
import '../exeption/geminiException.dart';
import 'ApiRequestBuilder.dart';
import 'petition_ai/gemini/GeminiHTTPService.dart';
import 'petition_ai/gemini/geminiStreamingService.dart';

class AiService {
  final GeminiHTTPService geminiHTTPService;
  final GeminiStreamingService geminiStreamingService;
  final AiRequestNotifier aiRequestNotifier;

  AiService({
    required this.geminiHTTPService,
    required this.geminiStreamingService,
    required this.aiRequestNotifier,
  });

  String _formPrompt(
      String basePrompt,
      List<PhraseObject> phraseObjectsList,
      String originalLanguage,
      String translationLanguage, {
        Map<String, dynamic>? extraMetadata,
      }) {
    final sortPhraseList = List<PhraseObject>.from(phraseObjectsList)
      ..sort((a, b) => (a.phraseOrder ?? 0).compareTo(b.phraseOrder ?? 0));

    final simplifiedPhrasesList = sortPhraseList.map((phrase) {
      return {
        'id': phrase.id,
        'videoId': phrase.videoId,
        'phraseOrder': phrase.phraseOrder,
        'originalText': phrase.originalPhrase ?? '',
        'startTime': phrase.startTime?.toIso8601String(),
        'endTime': phrase.endTime?.toIso8601String(),
      };
    }).toList();

    final defaultMetadata = {
      'sourceLanguage': originalLanguage,
      'targetLanguage': translationLanguage,
      'playerId': null,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final metadata = {
      ...defaultMetadata,
      if (extraMetadata != null) ...extraMetadata,
    };

    final payload = {
      'metadata': metadata,
      'phrases': simplifiedPhrasesList,
    };

    final String jsonData = jsonEncode(payload);

    return '''
$basePrompt

INPUT_DATA (JSON):
$jsonData

RESPONSE RULES:
- OUTPUT MUST BE valid JSON only (no markdown).
- If multiple phrases provided, return a JSON array (batch mode).
- Validate continuity of w_pos and tr_pos as integers starting from 1.
- If a phrase cannot be parsed, return an object with "phraseId" and "error" fields for that item.
- Do not include any extra commentary.
''';
  }

  Future<void> translatePhraseList({
    required Ref ref,
    required List<PhraseObject> phraseObjectsList,
    required String originalLanguage,
    required String translationLanguage,
    Map<String, dynamic>? extraMetadata,
  }) async {
    int attempts = 0;
    const int maxRetries = 1;

    final pipelineResult = await PipelineManager.buildForCurrentVideo(
      ref,
      pipelineId: 'total_v1',
    );

    if (pipelineResult == null) {
      throw Exception('PipelineBuildResult is null. Відео не знайдено.');
    }

    final translationStep = pipelineResult.stepOf(PipelineStepType.translation);
    final modelToUse = translationStep.model;
    final basePrompt = translationStep.prompt;

    final bool isStreamingMode = modelToUse.supportsStreaming;

    final String fullUrl = await ApiRequestBuilder.buildUrl(
      modelToUse,
      isStreaming: isStreamingMode,
    );

    aiRequestNotifier.start(
      processingMethod: isStreamingMode ? AiProcessingMethod.streaming : AiProcessingMethod.fullResponse,
      modelName: modelToUse.name,
      itemsTotal: phraseObjectsList.length,
    );

    try {
      while (true) {
        try {
          attempts++;
          aiRequestNotifier.setRetry(attempts - 1);
          aiRequestNotifier.setSending();

          final String promptWithPhrases = _formPrompt(
            basePrompt,
            phraseObjectsList,
            originalLanguage,
            translationLanguage,
            extraMetadata: extraMetadata,
          );

          if (modelToUse.name.toLowerCase().contains('gemini') || modelToUse.name.toLowerCase().contains('gemma')) {
            if (isStreamingMode) {
              aiRequestNotifier.setStreamingResponse();
              await geminiStreamingService.sendStreamAndParseRequest(fullUrl, promptWithPhrases);
            } else {
              aiRequestNotifier.setWaitingResponse();
              await geminiHTTPService.sendAndParseRequest(fullUrl, promptWithPhrases);
            }
          } else {
            throw Exception("Model type ${modelToUse.name} is not supported yet");
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
      // await AiModelManager().incrementUsage(modelToUse.name);
    }
  }
}