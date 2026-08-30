import 'package:eiga/backend/data/dto/AiModelSettingsDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
import 'package:eiga/ui/styles/ModelSelectionTheme.dart';
import 'package:flutter/material.dart';

import '../../../config/modelsUrl/TranslationPipelineStep.dart';

class ModelWidget extends StatefulWidget {
  final AiModelSettingsDTO modelDTO;
  final AiModelEntry modelEntry;
  final TranslationPipelineStep step;
  final bool isActive;
  final VoidCallback? onToggleStreaming;
  final VoidCallback onSelect;

  const ModelWidget({
    super.key,
    required this.modelDTO,
    required this.modelEntry,
    required this.step,
    required this.isActive,
    required this.onSelect,
    this.onToggleStreaming,
  });

  @override
  State<ModelWidget> createState() => _ModelWidgetState();
}

class _ModelWidgetState extends State<ModelWidget> {
  Color _usageColor(ModelSelectionTheme theme) {
    final used = widget.modelDTO.used;
    final max = widget.modelDTO.currentDailyMaxLimit;
    if (max <= 0) return theme.mutedText;
    final ratio = used / max;
    if (ratio >= 1) return Colors.redAccent;
    if (ratio >= 0.75) return Colors.orangeAccent;
    return theme.primaryAccent;
  }

  int get _limitSegmentsTotal => 10;

  int get _limitSegmentsActive {
    final used = widget.modelDTO.used;
    final max = widget.modelDTO.currentDailyMaxLimit;
    if (max <= 0) return 0;
    final ratio = (used / max).clamp(0.0, 1.0);
    return (ratio * _limitSegmentsTotal).ceil().clamp(0, _limitSegmentsTotal);
  }

  int get _speedSegmentsActive {
    switch (widget.modelEntry.speed) {
      case ModelSpeed.ultraFast: return 4;
      case ModelSpeed.fast: return 3;
      case ModelSpeed.medium: return 2;
      case ModelSpeed.slow: return 1;
    }
  }

  int get _qualitySegmentsActive {
    switch (widget.modelEntry.quality) {
      case ModelQuality.frontier: return 4;
      case ModelQuality.high: return 3;
      case ModelQuality.standard: return 2;
      case ModelQuality.basic: return 1;
    }
  }

  Widget _segmentBar({
    required int active,
    required int total,
    required Color activeColor,
    required Color offColor,
    double width = 16,
    double height = 9,
    double gap = 4,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isOn = i < active;
        return Container(
          margin: EdgeInsets.only(right: i == total - 1 ? 0 : gap),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isOn ? activeColor : offColor,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _labeledBar(String label, Widget bar, ModelSelectionTheme theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 42,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: theme.mutedText, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 6),
        bar,
      ],
    );
  }

  Widget _streamingToggle(ModelSelectionTheme theme) {
    final supportsStreaming = widget.modelEntry.supportsStreaming;
    final isOn = supportsStreaming && widget.modelDTO.currentStreamingEnabled;

    final activeColor = theme.primaryAccent;
    final trackColor = !supportsStreaming
        ? theme.segmentOffColor
        : (isOn ? activeColor.withValues(alpha: 0.2) : theme.segmentOffColor);

    final labelColor = !supportsStreaming ? theme.mutedText : (isOn ? activeColor : theme.mutedText);

    final toggleContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          !supportsStreaming ? 'No streaming' : (isOn ? 'Streaming' : 'Streaming off'),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: labelColor),
        ),
        const SizedBox(width: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 52,
          height: 28,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
              ],
            ),
            child: !supportsStreaming
                ? Icon(Icons.close_rounded, size: 13, color: theme.mutedText)
                : Icon(
              isOn ? Icons.bolt_rounded : Icons.bolt_outlined,
              size: 13,
              color: isOn ? activeColor : theme.mutedText,
            ),
          ),
        ),
      ],
    );

    if (!supportsStreaming) return Opacity(opacity: 0.5, child: toggleContent);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onToggleStreaming,
      child: toggleContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ModelSelectionTheme.of(context);
    final usageColor = _usageColor(theme);

    return GestureDetector(
      onTap: widget.onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: widget.isActive ? theme.activeCardBackground : theme.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.isActive ? theme.activeCardBorder : theme.cardBorder,
            width: widget.isActive ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: usageColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.modelDTO.name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.normalText),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.step.displayName,
                        style: TextStyle(fontSize: 11, color: theme.mutedText),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${widget.modelDTO.used}/${widget.modelDTO.currentDailyMaxLimit}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.normalText),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _labeledBar('Limit', _segmentBar(active: _limitSegmentsActive, total: _limitSegmentsTotal, activeColor: usageColor, offColor: theme.segmentOffColor), theme),
            const SizedBox(height: 8),
            _labeledBar('Speed', _segmentBar(active: _speedSegmentsActive, total: 4, activeColor: Colors.blue, offColor: theme.segmentOffColor), theme),
            const SizedBox(height: 8),
            _labeledBar('Power', _segmentBar(active: _qualitySegmentsActive, total: 4, activeColor: theme.primaryAccent, offColor: theme.segmentOffColor), theme),
            if (widget.step == TranslationPipelineStep.parse) ...[
              const SizedBox(height: 12),
              Align(alignment: Alignment.bottomRight, child: _streamingToggle(theme)),
            ],
          ],
        ),
      ),
    );
  }
}