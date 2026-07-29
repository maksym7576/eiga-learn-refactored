import '../../../config/modelsUrl/AIModelsURLData.dart'; // AiModelEntry
import '../../../config/modelsUrl/TranslationPipelineStep.dart';

enum PipelineStepType { contextResearch, translation, parser }

extension PipelineStepTypeMapping on PipelineStepType {
  TranslationPipelineStep get asTranslationStep {
    switch (this) {
      case PipelineStepType.contextResearch:
        return TranslationPipelineStep.research;
      case PipelineStepType.translation:
        return TranslationPipelineStep.translate;
      case PipelineStepType.parser:
        return TranslationPipelineStep.parse;
    }
  }
}

class PipelineStepResult {
  final PipelineStepType type;
  final AiModelEntry model;
  final String prompt;

  const PipelineStepResult({
    required this.type,
    required this.model,
    required this.prompt,
  });
}

class PipelineBuildResult {
  final String pipelineId;
  final List<PipelineStepResult> steps;

  const PipelineBuildResult({
    required this.pipelineId,
    required this.steps,
  });

  PipelineStepResult stepOf(PipelineStepType type) =>
      steps.firstWhere((s) => s.type == type);
}