import 'dart:async';

import 'package:eiga/backend/data/dto/AiModelSettingsDTO.dart';
import 'package:eiga/ui/widgets/appBarWidgets/modelsPreviewWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/modelsUrl/TranslationPipelineStep.dart';
import '../../../providers/ai_models_state_provider.dart';
import '../../styles/AppAppBarTheme.dart';
import '../dialogs/AppBottomSheet.dart';

class AppBarWidget extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final TranslationPipelineStep step;

  const AppBarWidget({
    super.key,
    this.step = TranslationPipelineStep.translate,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends ConsumerState<AppBarWidget> {
  bool _isModelDialogOpen = false;

  late int _currentStepIndex;
  Timer? _cycleTimer;

  static const Duration _holdDuration = Duration(seconds: 3);
  static const Duration _slideDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _currentStepIndex = widget.step.index;
    _startCycle();
  }

  void _startCycle() {
    _cycleTimer?.cancel();
    _cycleTimer = Timer.periodic(_holdDuration, (_) {
      if (!mounted || _isModelDialogOpen) return;
      setState(() {
        _currentStepIndex =
            (_currentStepIndex + 1) % TranslationPipelineStep.values.length;
      });
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    super.dispose();
  }

  TranslationPipelineStep get _currentStep =>
      TranslationPipelineStep.values[_currentStepIndex];

  void _showAllModelsDialog() async {
    _cycleTimer?.cancel();
    setState(() => _isModelDialogOpen = true);
    try {
      await AppBottomSheet.show(
        context: context,
        barrierLabel: "ModelsLabel",
        child: ModelPreviewWidget(initialStep: _currentStep),
      );
    } finally {
      if (mounted) setState(() => _isModelDialogOpen = false);
    }
    _startCycle();
  }

  @override
  Widget build(BuildContext context) {
    final step = _currentStep;
    final aiState = ref.watch(aiModelsProvider);
    final stepModels = ref.watch(modelsForStepProvider(step));

    final activeName = aiState.activeNameByStep[step];
    final matches = stepModels.where((m) => m.name == activeName);

    final AiModelSettingsDTO selectedItem = matches.isNotEmpty
        ? matches.first
        : const AiModelSettingsDTO(
      name: 'No model',
      url: 'No',
      currentMaxLimit: 0,
      defaultMaxLimit: 0,
      isMaxLimitCustom: false,
      used: 0,
      currentDailyMaxLimit: 0,
      defaultDailyMaxLimit: 0,
      isDailyMaxLimitCustom: false,
      dailyUsed: 0,
      currentPhrasesPerRequest: 0,
      defaultPhrasesPerRequest: 0,
      isPhrasesPerRequestCustom: false,
      currentStreamingEnabled: false,
      defaultStreamingEnabled: false,
      isStreamingCustom: false,
    );

    final theme = AppAppBarTheme.of(context);

    return AppBar(
      backgroundColor: theme.backgroundColor,
      elevation: 0,
      title: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            'eiga',
            style: theme.logoStyle,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: _showAllModelsDialog,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCirc,
                decoration: BoxDecoration(
                  color: _isModelDialogOpen
                      ? theme.selectorActiveBackground
                      : theme.selectorBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _isModelDialogOpen
                        ? theme.selectorActiveBorder
                        : theme.selectorBorder,
                    width: _isModelDialogOpen ? 2.0 : 1.5,
                  ),
                  boxShadow: _isModelDialogOpen
                      ? theme.selectorActiveShadow
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedSwitcher(
                    duration: _slideDuration,
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      final isIncoming =
                          child.key == ValueKey(_currentStepIndex);

                      final offsetTween = isIncoming
                          ? Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      )
                          : Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      );

                      return SlideTransition(
                        position: offsetTween.animate(animation),
                        child: child,
                      );
                    },
                    child: Padding(
                      key: ValueKey(_currentStepIndex),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.indicatorColor,
                              shape: BoxShape.circle,
                              boxShadow: theme.indicatorShadow,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.displayName.toUpperCase(),
                                  style: theme.stepLabelStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  selectedItem.name,
                                  style: theme.modelNameStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.badgeBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${selectedItem.used}/${selectedItem.currentDailyMaxLimit}',
                              style: theme.badgeTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.iconColor),
          onPressed: () {
            context.push('/settings');
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}