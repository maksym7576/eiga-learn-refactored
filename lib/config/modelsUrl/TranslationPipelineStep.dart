enum TranslationPipelineStep {

  research,

  translate,

  parse;

  String get displayName {
    switch (this) {
      case TranslationPipelineStep.research: return 'Analyze';
      case TranslationPipelineStep.translate: return 'Translation';
      case TranslationPipelineStep.parse: return 'Morpheme analysis';
    }
  }
}