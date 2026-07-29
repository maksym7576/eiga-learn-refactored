import 'package:eiga/config/prompts/promptManager.dart';
import '../../../backend/data/models/videoObject.dart';
import 'PipelineAbstract.dart';
import 'PipelineStepType.dart';

class TotalPipeline extends PipelineAbstract {
  @override
  String get id => 'total_v1';

  @override
  List<PipelineStepType> get stepTypes => const [
    PipelineStepType.translation,
  ];

  @override
  String promptFor(PipelineStepType type, VideoObject video) {
    return PromptManager.getPrompt(
      type: PromptType.total,
      sourceLanguage: video.originalLanguage ?? '',
      targetLanguage: video.translatedLanguage ?? '',
      title: video.videoName ?? video.nameJumaku ?? '',
      season: video.season ?? '',
      episodeNumber: video.episode ?? '',
      contextBlock: video.researchInformation ?? '',
    );
  }
}