import '../../../backend/data/models/videoObject.dart';
import '../../prompts/promptManager.dart';
import 'PipelineAbstract.dart';
import 'PipelineStepType.dart';

class ContextTranslationPipeline extends PipelineAbstract {
  @override
  String get id => 'context_translation_v1';

  @override
  List<PipelineStepType> get stepTypes => const [
    PipelineStepType.contextResearch,
    PipelineStepType.translation,
    PipelineStepType.parser,
  ];

  @override
  String promptFor(PipelineStepType type, VideoObject video) {
    final sourceLanguage = video.originalLanguage ?? '';
    final targetLanguage = video.translatedLanguage ?? '';
    final title = video.videoName ?? video.nameJumaku ?? '';

    switch (type) {
      case PipelineStepType.contextResearch:
        return PromptManager.getPrompt(
          type: PromptType.contextResearch,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          title: title,
          season: video.season ?? '',
          episodeNumber: video.episode ?? '',
        );

      case PipelineStepType.translation:
        return PromptManager.getPrompt(
          type: PromptType.translation,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          title: title,
          season: video.season ?? '',
          episodeNumber: video.episode ?? '',
          contextBlock: video.researchInformation ?? '',
        );

      case PipelineStepType.parser:
        return PromptManager.getPrompt(
          type: PromptType.parser,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          title: title,
        );
    }
  }
}