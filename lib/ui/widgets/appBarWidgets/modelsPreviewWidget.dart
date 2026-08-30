import 'package:eiga/backend/data/dto/AiModelSettingsDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
import 'package:eiga/ui/styles/ModelSelectionTheme.dart';
import 'package:eiga/ui/widgets/appBarWidgets/modelWidget.dart';
import 'package:eiga/ui/widgets/buttons/EqualToggleButtons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/modelsUrl/TranslationPipelineStep.dart';
import '../../../providers/ai_models_state_provider.dart';

class ModelPreviewWidget extends ConsumerStatefulWidget {
  final TranslationPipelineStep initialStep;

  const ModelPreviewWidget({
    super.key,
    this.initialStep = TranslationPipelineStep.research,
  });

  @override
  ConsumerState<ModelPreviewWidget> createState() =>
      _ModelPreviewWidgetState();
}

class _ModelPreviewWidgetState extends ConsumerState<ModelPreviewWidget> {
  late TranslationPipelineStep _activeStep;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _activeStep = widget.initialStep;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  AiModelEntry _entryFor(AiModelSettingsDTO dto) {
    return aiModels.firstWhere(
          (e) => e.name == dto.name,
      orElse: () => aiModels.first,
    );
  }

  Future<void> _selectModel(String modelName) async {
    await ref
        .read(aiModelsProvider.notifier)
        .setActiveModel(_activeStep, modelName);

    if (!mounted) return;

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ModelSelectionTheme.of(context);
    final aiState = ref.watch(aiModelsProvider);
    final isLoading = aiState.isLoading;
    final remainingTime = aiState.remainingTime;

    final stepModels = ref.watch(modelsForStepProvider(_activeStep));

    final activeName = aiState.activeNameByStep[_activeStep];
    final matches = stepModels.where((m) => m.name == activeName);
    final selectedModel = matches.isEmpty ? null : matches.first;
    final otherModels =
    stepModels.where((m) => m.name != activeName).toList();

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(remainingTime, theme),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: EqualToggleButtons<TranslationPipelineStep>(
              items: TranslationPipelineStep.values,
              activeItem: _activeStep,
              onChanged: (step) => setState(() => _activeStep = step),
              labelBuilder: (step) => step.displayName,
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: theme.primaryAccent,
              ),
            )
                : selectedModel == null
                ? Center(
              child: Text(
                'No models available for this step',
                style: TextStyle(color: theme.mutedText),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              itemCount: otherModels.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ModelWidget(
                    modelDTO: selectedModel,
                    modelEntry: _entryFor(selectedModel),
                    step: _activeStep,
                    isActive: true,
                    onSelect: () => _selectModel(selectedModel.name),
                    onToggleStreaming: () => ref
                        .read(aiModelsProvider.notifier)
                        .toggleStreaming(selectedModel),
                  );
                }
                final model = otherModels[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ModelWidget(
                    modelDTO: model,
                    modelEntry: _entryFor(model),
                    step: _activeStep,
                    isActive: false,
                    onSelect: () => _selectModel(model.name),
                    onToggleStreaming: () => ref
                        .read(aiModelsProvider.notifier)
                        .toggleStreaming(model),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String remainingTime, ModelSelectionTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 26,
              color: theme.primaryAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Models',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: theme.normalText,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryAccent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: theme.primaryAccent.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Reset in $remainingTime',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: theme.primaryAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Select the model for this step',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.selectionAccentColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 20, color: theme.normalText),
            ),
          ),
        ],
      ),
    );
  }
}