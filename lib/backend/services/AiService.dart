import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/videoObject.dart';

import '../../config/modelsUrl/AIModelsURLData.dart';
import '../../config/pipeline/translationPeplines/PipelineManager.dart';
import '../../config/pipeline/translationPeplines/PipelineStepType.dart';
import '../../providers/AiRequestPhase.dart';
import '../../providers/aiTrackerProvider.dart';
import '../../providers/servicesProviders.dart';
import '../../providers/videoDataProviders.dart';
import '../exeption/AiUserFacingError.dart';
import '../exeption/geminiException.dart';
import 'ApiRequestBuilder.dart';
import 'petition_ai/gemini/GeminiHTTPService.dart';
import 'petition_ai/gemini/geminiStreamingService.dart';


class AiService {
  final Ref ref;
  final GeminiStreamingService geminiStreamingService;

  AiService({
    required this.ref,
    required this.geminiStreamingService,
  });

  GeminiHTTPService get _geminiHTTPService => ref.read(geminiHTTPServiceProvider);

  Future<AiRequestResult> runTranslationForVideo({
    required Ref ref,
    required VideoObject video,
    required List<PhraseObject> phraseObjectsList,
    required String originalLanguage,
    required String translationLanguage,
    Map<String, dynamic>? extraMetadata,
  }) async {
    final String pipelineId = video.pepelineIndetificator ?? 'total_v1';

    switch (pipelineId) {
      case 'context_translation_v1':
        return await processContextTranslationPipeline(
          ref: ref,
          video: video,
          phraseObjectsList: phraseObjectsList,
          originalLanguage: originalLanguage,
          translationLanguage: translationLanguage,
          extraMetadata: extraMetadata,
        );

      case 'total_v1':
        return await processTotalTranslationPipeline(
          ref: ref,
          video: video,
          phraseObjectsList: phraseObjectsList,
          originalLanguage: originalLanguage,
          translationLanguage: translationLanguage,
          extraMetadata: extraMetadata,
        );

      default:
        throw Exception(
          'Невідомий pepelineIndetificator: "$pipelineId". '
              'Очікується "total_v1" або "context_translation_v1".',
        );
    }
  }

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

    final payload = {
      'phrases': simplifiedPhrasesList,
    };

    final String jsonData = jsonEncode(payload);

    return '''
$basePrompt

INPUT_DATA (JSON):
$jsonData
''';
  }

  bool _isStreamingFor(AiModelEntry model) {
    return model.supportsStreaming;
  }

  Future<AiRequestResult> _fetchParseAndSaveData(AiModelEntry model, String url, String prompt, {List<int> expectedIds = const []}) async {
    final bool isStreamingMode = _isStreamingFor(model);

    if (model.provider == AiProvider.google) {
      if (isStreamingMode) {
        return await geminiStreamingService.fetchParseAndSaveData(url, prompt, expectedIds: expectedIds);
      } else {
        return await _geminiHTTPService.fetchParseAndSaveData(url, prompt, expectedIds: expectedIds);
      }
    }
    throw Exception("Provider ${model.provider} is not supported yet");
  }

  Future<AiRequestResult> _fetchEpisodeContext(Ref ref, AiModelEntry model, String url, String prompt) async {
    if (model.provider == AiProvider.google) {
      return await _geminiHTTPService.fetchEpisodeContext(ref, url, prompt);
    }
    throw Exception("Provider ${model.provider} is not supported yet");
  }

  Future<AiRequestResult> _fetchTranslations(AiModelEntry model, String url, String prompt, {List<int> expectedIds = const []}) async {
    if (model.provider == AiProvider.google) {
      try {
        final jsonString = await _geminiHTTPService.sendRequest(url, prompt);
        final Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
        return await _geminiHTTPService.phraseResponseHandler.saveTranslationsResponse(jsonResponse, expectedIds: expectedIds);
      } catch (e) {
        if (e is GeminiException) return AiRequestResult.failure(e.type);
        rethrow;
      }
    }
    throw Exception("Provider ${model.provider} is not supported yet");
  }

  Future<AiRequestResult> processTotalTranslationPipeline({
    required Ref ref,
    required VideoObject video,
    required List<PhraseObject> phraseObjectsList,
    required String originalLanguage,
    required String translationLanguage,
    Map<String, dynamic>? extraMetadata,
  }) async {
    int attempts = 0;
    const int maxRetries = 1;

    const String pipelineId = 'total_v1';
    final expectedIds = phraseObjectsList.map((e) => e.id).toList();

    final pipelineResult = await PipelineManager.buildForCurrentVideo(
      ref,
      pipelineId: pipelineId,
    );

    if (pipelineResult == null) {
      throw Exception('PipelineBuildResult is null. Відео не знайдено.');
    }

    final pipeline = PipelineManager.byId(pipelineId);
    if (pipeline == null) {
      throw Exception('Pipeline implementation not found for "$pipelineId".');
    }

    final translationStep = pipelineResult.stepOf(PipelineStepType.translation);
    final AiModelEntry modelToUse = translationStep.model;

    final String requestId = await ref.read(aiTrackerProvider.notifier).startRequest(
      modelName: modelToUse.name,
      requestType: 'Translation & Morphologization',
    );

    final String basePrompt = pipeline.promptFor(PipelineStepType.translation, video);

    final bool isStreamingMode = _isStreamingFor(modelToUse);
    final String fullUrl = await ApiRequestBuilder.buildUrl(
      modelToUse,
      forceStreamingOverride: isStreamingMode,
    );

    try {
      while (true) {
        try {
          attempts++;

          final String promptWithPhrases = _formPrompt(
            basePrompt,
            phraseObjectsList,
            originalLanguage,
            translationLanguage,
            extraMetadata: extraMetadata,
          );

          final result = await _fetchParseAndSaveData(modelToUse, fullUrl, promptWithPhrases, expectedIds: expectedIds);

          ref.read(aiTrackerProvider.notifier).completeRequest(
            requestId: requestId,
            phase: result.phase,
            failedPhraseIds: result.failedPhraseIds,
            videoId: video.id,
          );

          return result;
        } catch (error, stackTrace) {
          if (attempts > maxRetries) {
            ref.read(aiTrackerProvider.notifier).completeRequest(
              requestId: requestId,
              phase: AiRequestPhase.error,
              errorMessage: error.toString(),
              videoId: video.id,
            );
            _handleException(error, stackTrace, attempts, maxRetries);
          }
        }
      }
    } finally {}
  }

  Future<AiRequestResult> processContextTranslationPipeline({
    required Ref ref,
    required List<PhraseObject> phraseObjectsList,
    required String originalLanguage,
    required String translationLanguage,
    required VideoObject video,
    Map<String, dynamic>? extraMetadata,
  }) async {
    const String pipelineId = 'context_translation_v1';
    final expectedIds = phraseObjectsList.map((e) => e.id).toList();

    final pipelineResult = await PipelineManager.buildForCurrentVideo(
      ref,
      pipelineId: pipelineId,
    );

    if (pipelineResult == null) throw Exception('PipelineBuildResult is null.');

    final pipeline = PipelineManager.byId(pipelineId);
    if (pipeline == null) throw Exception('Pipeline implementation not found.');

    try {
      final researchData = ref.read(videoResearchInfoProvider).valueOrNull;
      final bool isResearchDone = researchData?.isResearchDone ?? video.isResearchDone ?? false;
      String? researchInfo = researchData?.researchInformation ?? video.researchInformation;

      if (!isResearchDone || researchInfo == null || researchInfo.isEmpty) {
        final contextStep = pipelineResult.stepOf(PipelineStepType.contextResearch);
        final AiModelEntry contextModel = contextStep.model;

        final String requestId = await ref.read(aiTrackerProvider.notifier).startRequest(
          modelName: contextModel.name,
          requestType: 'Context Analysis',
        );

        final contextUrl = await ApiRequestBuilder.buildUrl(contextModel, forceStreamingOverride: false);
        final String contextPrompt = pipeline.promptFor(PipelineStepType.contextResearch, video);

        final researchResult = await _fetchEpisodeContext(ref, contextModel, contextUrl, contextPrompt);

        ref.read(aiTrackerProvider.notifier).completeRequest(
          requestId: requestId,
          phase: researchResult.phase,
          videoId: video.id,
        );

        if (researchResult.phase != AiRequestPhase.success) return researchResult;

        video = video.copyWith(isResearchDone: true, researchInformation: researchInfo);
      }

      // 2. TRANSLATION
      final String translationPrompt = pipeline.promptFor(PipelineStepType.translation, video);
      final translationStep = pipelineResult.stepOf(PipelineStepType.translation);
      final AiModelEntry translationModel = translationStep.model;

      final String requestIdTranslation = await ref.read(aiTrackerProvider.notifier).startRequest(
        modelName: translationModel.name,
        requestType: 'Translation',
      );

      final translationUrl = await ApiRequestBuilder.buildUrl(translationModel, forceStreamingOverride: false);
      final fullTranslationPrompt = _formPrompt(translationPrompt, phraseObjectsList, originalLanguage, translationLanguage, extraMetadata: extraMetadata);

      final translationResult = await _fetchTranslations(translationModel, translationUrl, fullTranslationPrompt, expectedIds: expectedIds);

      ref.read(aiTrackerProvider.notifier).completeRequest(
        requestId: requestIdTranslation,
        phase: translationResult.phase,
        failedPhraseIds: translationResult.failedPhraseIds,
        videoId: video.id,
      );

      if (translationResult.phase != AiRequestPhase.success) return translationResult;

      final translationData = await _geminiHTTPService.sendRequest(translationUrl, fullTranslationPrompt);

      // 3. MORPHOLOGIZATION
      final parserPrompt = pipeline.promptFor(PipelineStepType.parser, video);
      final parserStep = pipelineResult.stepOf(PipelineStepType.parser);
      final AiModelEntry parserModel = parserStep.model;

      final String requestIdParser = await ref.read(aiTrackerProvider.notifier).startRequest(
        modelName: parserModel.name,
        requestType: 'Morphologization',
      );

      final bool parserIsStreaming = _isStreamingFor(parserModel);
      final parserUrl = await ApiRequestBuilder.buildUrl(parserModel, forceStreamingOverride: parserIsStreaming);
      final finalParserPrompt = '$parserPrompt\n\nTRANSLATION_DATA:\n$translationData';

      final parserResult = await _fetchParseAndSaveData(parserModel, parserUrl, finalParserPrompt, expectedIds: expectedIds);

      ref.read(aiTrackerProvider.notifier).completeRequest(
        requestId: requestIdParser,
        phase: parserResult.phase,
        failedPhraseIds: parserResult.failedPhraseIds,
        videoId: video.id,
      );

      return parserResult;
    } catch (error, stackTrace) {
      _handleException(error, stackTrace, 1, 1);
      return AiRequestResult.failure(AiErrorType.unknown);
    }
  }

  void _handleException(Object error, StackTrace stackTrace, int attempts, int maxRetries) {
    if (error is GeminiGeneralException ||
        error is GeminiModelExpiredException ||
        error is GeminiIncorrectTokenException) {
      throw error;
    }

    bool isRetryable = error is GeminiServerException || error is Exception;
    if (!(isRetryable && attempts <= maxRetries)) {
      throw error;
    }
  }
}
