import 'package:eiga/backend/data/dto/AIModelDataDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
import 'package:eiga/ui/widgets/appBarWidgets/modelWidget.dart';
import 'package:eiga/ui/widgets/buttons/EqualToggleButtons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/modelsUrl/TranslationPipelineStep.dart';
import '../../../providers/AiModelsStateProvuder.dart';

class ModelPreviewWidget extends ConsumerStatefulWidget {
  final TranslationPipelineStep initialStep;

  const ModelPreviewWidget({
    Key? key,
    this.initialStep = TranslationPipelineStep.research,
  }) : super(key: key);

  @override
  ConsumerState<ModelPreviewWidget> createState() =>
      _ModelPreviewWidgetState();
}

class _ModelPreviewWidgetState extends ConsumerState<ModelPreviewWidget> {
  late TranslationPipelineStep _activeStep;

  /// Контролер списку моделей: активна модель завжди рендериться першою
  /// (index == 0), тому при виборі нової моделі список перебудовується
  /// і потрібно плавно проскролити назад до верху, а не смикати екран.
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

  AiModelEntry _entryFor(AiModelDataDTO dto) {
    return aiModels.firstWhere(
          (e) => e.name == dto.name,
      orElse: () => aiModels.first,
    );
  }

  /// Вибір моделі: пишемо новий active model через провайдер (а не напряму
  /// в AiModelManager, як було раніше в ModelWidget) — тому
  /// aiModelsProvider.state.activeNameByStep коректно оновлюється і
  /// обрана модель одразу переїжджає на позицію "активної" (index == 0).
  ///
  /// Вікно НЕ закривається — Navigator.pop тут навмисно відсутній.
  /// Замість цього після оновлення стану плавно скролимо список назад
  /// до верху, щоб користувач одразу побачив нову активну модель.
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
    // Таймер, дані моделей і ресет тепер повністю живуть у провайдері.
    final aiState = ref.watch(aiModelsProvider);
    final isLoading = aiState.isLoading;
    final remainingTime = aiState.remainingTime;

    // Список моделей для активного кроку — вже відфільтрований і
    // відсортований провайдером (напр. для analyze лишаться тільки
    // моделі з web search).
    final stepModels = ref.watch(modelsForStepProvider(_activeStep));

    final activeName = aiState.activeNameByStep[_activeStep];
    final matches = stepModels.where((m) => m.name == activeName);
    final selectedModel = matches.isEmpty ? null : matches.first;
    final otherModels =
    stepModels.where((m) => m.name != activeName).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(remainingTime),
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
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
              ),
            )
                : selectedModel == null
                ? const Center(
              child: Text(
                'No models available for this step',
                style: TextStyle(color: Colors.black54),
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

  /// Оновлена шапка: іконка + заголовок ліворуч, чіп з таймером під
  /// підзаголовком, кругла кнопка закриття справа.
  Widget _buildHeader(String remainingTime) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 26,
              color: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(width: 12),
          // Компактна текстова частина
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Models',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Компактний бейдж таймера поруч із заголовком
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: Colors.deepPurpleAccent.withOpacity(0.8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Reset in $remainingTime',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurpleAccent,
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
                    color: Colors.black.withOpacity(0.45),
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
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}