import '../../../backend/data/models/videoObject.dart';
import '../../modelsUrl/AiModelManager.dart'; // підстав свій реальний шлях
import 'PipelineStepType.dart';

abstract class PipelineAbstract {
  String get id;

  List<PipelineStepType> get stepTypes;

  String promptFor(PipelineStepType type, VideoObject video);

  Future<PipelineBuildResult> build(VideoObject video) async {
    final aiModelManager = AiModelManager();

    final steps = <PipelineStepResult>[];
    for (final type in stepTypes) {
      final model = await aiModelManager.getActiveModel(
        type.asTranslationStep.name,
      );
      steps.add(PipelineStepResult(
        type: type,
        model: model,
        prompt: promptFor(type, video),
      ));
    }

    return PipelineBuildResult(pipelineId: id, steps: steps);
  }
}