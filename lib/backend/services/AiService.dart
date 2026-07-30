import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/videoObject.dart';

import '../../config/modelsUrl/AIModelsURLData.dart';
import '../../config/pipeline/translationPeplines/PipelineManager.dart';
import '../../config/pipeline/translationPeplines/PipelineStepType.dart';
import '../../providers/servicesProviders.dart';
import '../../providers/videoDataProviders.dart';
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

  Future<void> runTranslationForVideo({
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
        await processContextTranslationPipeline(
          ref: ref,
          video: video,
          phraseObjectsList: phraseObjectsList,
          originalLanguage: originalLanguage,
          translationLanguage: translationLanguage,
          extraMetadata: extraMetadata,
        );
        break;

      case 'total_v1':
        await processTotalTranslationPipeline(
          ref: ref,
          video: video,
          phraseObjectsList: phraseObjectsList,
          originalLanguage: originalLanguage,
          translationLanguage: translationLanguage,
          extraMetadata: extraMetadata,
        );
        break;

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

  Future<void> _fetchParseAndSaveData(AiModelEntry model, String url, String prompt) async {
    final bool isStreamingMode = _isStreamingFor(model);

    switch (model.provider) {
      case AiProvider.google:
        if (isStreamingMode) {
          await geminiStreamingService.fetchParseAndSaveData(url, prompt);
        } else {
          await _geminiHTTPService.fetchParseAndSaveData(url, prompt);
        }
        break;

      case AiProvider.openai:
      case AiProvider.anthropic:
      case AiProvider.custom:
        throw Exception("Provider ${model.provider} is not supported yet");
    }
  }

  Future<void> _fetchEpisodeContext(Ref ref, AiModelEntry model, String url, String prompt) async {

    switch (model.provider) {
      case AiProvider.google:
         _geminiHTTPService.fetchEpisodeContext(ref, url, prompt);

      case AiProvider.openai:
      case AiProvider.anthropic:
      case AiProvider.custom:
        throw Exception("Provider ${model.provider} is not supported yet");
    }
  }

  Future<Map<String, dynamic>> _fetchTranslations(AiModelEntry model, String url, String prompt) async {

    switch (model.provider) {
      case AiProvider.google:
        return _geminiHTTPService.fetchTranslations(url, prompt);

      case AiProvider.openai:
      case AiProvider.anthropic:
      case AiProvider.custom:
        throw Exception("Provider ${model.provider} is not supported yet");
    }
  }

  Future<void> processTotalTranslationPipeline({
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

          print('========== TRANSLATE LIST PROMPT ==========');
          print(promptWithPhrases);
          print('===========================================');

          await _fetchParseAndSaveData(modelToUse, fullUrl, promptWithPhrases);

          break;
        } catch (error, stackTrace) {
          _handleException(error, stackTrace, attempts, maxRetries);
        }
      }
    } finally {}
  }

  Future<void> processContextTranslationPipeline({
    required Ref ref,
    required List<PhraseObject> phraseObjectsList,
    required String originalLanguage,
    required String translationLanguage,
    required VideoObject video,
    Map<String, dynamic>? extraMetadata,
  }) async {
    const String pipelineId = 'context_translation_v1';

    final pipelineResult = await PipelineManager.buildForCurrentVideo(
      ref,
      pipelineId: pipelineId,
    );

    if (pipelineResult == null) throw Exception('PipelineBuildResult is null.');

    final pipeline = PipelineManager.byId(pipelineId);
    if (pipeline == null) throw Exception('Pipeline implementation not found.');



    try {

      // Читаємо дані з провайдера або з поточного об'єкта video
      final researchData = ref.read(videoResearchInfoProvider).valueOrNull;
      final bool isResearchDone = researchData?.isResearchDone ?? video.isResearchDone ?? false;
      String? researchInfo = researchData?.researchInformation ?? video.researchInformation;

      if (!isResearchDone || researchInfo == null || researchInfo.isEmpty) {
        // 1. ЕТАП: ДОСЛІДЖЕННЯ КОНТЕКСТУ (виконується, якщо ще не зроблено)
        final contextStep = pipelineResult.stepOf(PipelineStepType.contextResearch);
        final AiModelEntry contextModel = contextStep.model;
        final contextUrl = await ApiRequestBuilder.buildUrl(contextModel, forceStreamingOverride: false);

        final String contextPrompt = pipeline.promptFor(PipelineStepType.contextResearch, video);

        print('========== 1. CONTEXT PROMPT ==========');
        print(contextPrompt);
        print('=======================================');

        // Збереження результату у contextData
        await _fetchEpisodeContext(ref, contextModel, contextUrl, contextPrompt);

        // Оновлюємо video локально для наступних етапів
        video = video.copyWith(
          isResearchDone: true,
          researchInformation: researchInfo,
        );

      } else {
        print('========== 1. CONTEXT RESEARCH SKIPPED (ALREADY DONE) ==========');

        // Синхронізуємо об'єкт video з даними з провайдера для наступного кроку
        video = video.copyWith(
          isResearchDone: true,
          researchInformation: researchInfo,
        );
      }

      // 2. ЕТАП: ПЕРЕКЛАД (використовує оновлений об'єкт video з researchInformation)
      final String translationPrompt = pipeline.promptFor(PipelineStepType.translation, video);

      final translationStep = pipelineResult.stepOf(PipelineStepType.translation);
      final AiModelEntry translationModel = translationStep.model;
      final translationUrl = await ApiRequestBuilder.buildUrl(translationModel, forceStreamingOverride: false);

      final fullTranslationPrompt = _formPrompt(
        translationPrompt,
        phraseObjectsList,
        originalLanguage,
        translationLanguage,
        extraMetadata: extraMetadata,
      );

      print('========== 2. TRANSLATION PROMPT ==========');
      print(fullTranslationPrompt);
      print('===========================================');

      final translationData = await _fetchTranslations(translationModel, translationUrl, fullTranslationPrompt);

      // 3. ЕТАП: ПАРСЕР
      final parserPrompt = pipeline.promptFor(PipelineStepType.parser, video);
      final parserStep = pipelineResult.stepOf(PipelineStepType.parser);
      final AiModelEntry parserModel = parserStep.model;
      final bool parserIsStreaming = _isStreamingFor(parserModel);
      final parserUrl = await ApiRequestBuilder.buildUrl(parserModel, forceStreamingOverride: parserIsStreaming);

      final finalParserPrompt = '$parserPrompt\n\nTRANSLATION_DATA:\n${jsonEncode(translationData)}';

      print('========== 3. PARSER PROMPT ==========');
      print(finalParserPrompt);
      print('======================================');

      await _fetchParseAndSaveData(parserModel, parserUrl, finalParserPrompt);

    } catch (error, stackTrace) {
      _handleException(error, stackTrace, 1, 1);
    }
  }

  void _handleException(Object error, StackTrace stackTrace, int attempts, int maxRetries) {
    if (error is GeminiGeneralException ||
        error is GeminiModelExpiredException ||
        error is GeminiIncorrectTokenException) {
      throw error;
    }

    bool isRetryable = error is GeminiServerException || error is Exception;


    if (isRetryable && attempts <= maxRetries) {
      // Тут можна додати логіку повторної спроби
    } else {
      throw error;
    }
  }
}