import 'package:eiga/backend/data/dto/AiModelSettingsDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
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

  Color get _usageColor {
    final used = widget.modelDTO.used;
    final max = widget.modelDTO.currentDailyMaxLimit;
    if (max <= 0) return Colors.grey;
    final ratio = used / max;
    if (ratio >= 1) return Colors.red;
    if (ratio >= 0.75) return Colors.deepOrange;
    if (ratio >= 0.4) return Colors.amber[700]!;
    return Colors.green;
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
      case ModelSpeed.ultraFast:
        return 4;
      case ModelSpeed.fast:
        return 3;
      case ModelSpeed.medium:
        return 2;
      case ModelSpeed.slow:
        return 1;
    }
  }

  int get _qualitySegmentsActive {
    switch (widget.modelEntry.quality) {
      case ModelQuality.frontier:
        return 4;
      case ModelQuality.high:
        return 3;
      case ModelQuality.standard:
        return 2;
      case ModelQuality.basic:
        return 1;
    }
  }

  static const List<Color> _qualityColors = [
    Colors.grey,
    Colors.teal,
    Colors.blue,
    Colors.purple,
  ];

  Widget _segmentBar({
    required int active,
    required int total,
    required Color Function(int index) colorOf,
    double width = 16,
    double height = 9,
    double gap = 4,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isOn = i < active;
        final color = colorOf(i);
        return Container(
          margin: EdgeInsets.only(right: i == total - 1 ? 0 : gap),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isOn ? color : color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _labeledBar(String label, Widget bar) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 42,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 6),
        bar,
      ],
    );
  }

  Widget _streamingToggle() {
    final supportsStreaming = widget.modelEntry.supportsStreaming;
    final isOn = supportsStreaming && widget.modelDTO.currentStreamingEnabled;

    const activeColor = Colors.blueAccent;

    final trackColor = !supportsStreaming
        ? Colors.grey.withValues(alpha: 0.18)
        : (isOn ? activeColor : Colors.grey.withValues(alpha: 0.35));

    final label = !supportsStreaming
        ? 'No streaming'
        : (isOn ? 'Streaming' : 'Streaming off');

    final labelColor = !supportsStreaming
        ? Colors.grey
        : (isOn ? activeColor : Colors.grey[600]);

    final toggleContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: labelColor,
          ),
        ),
        const SizedBox(width: 8),
        // Сам "повзунок".
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          width: 52,
          height: 28,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: !supportsStreaming
                ? const Icon(Icons.close_rounded, size: 13, color: Colors.grey)
                : Icon(
              isOn ? Icons.bolt_rounded : Icons.bolt_outlined,
              size: 13,
              color: isOn ? activeColor : Colors.grey,
            ),
          ),
        ),
      ],
    );

    // Модель взагалі не вміє стрімити — лише інформаційно, не тапається.
    if (!supportsStreaming) {
      return Opacity(opacity: 0.55, child: toggleContent);
    }

    // Окремий GestureDetector: тап тут перемикає стрімінг і НЕ спрацьовує
    // як вибір моделі / закриття картки (зовнішній onTap картки).
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onToggleStreaming,
      child: toggleContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.modelDTO;
    final used = model.used;
    final maxLimit = model.currentDailyMaxLimit;
    final usageColor = _usageColor;

    return GestureDetector(
      onTap: widget.onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: widget.isActive ? Colors.green.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.isActive ? Colors.green[400]! : Colors.grey[300]!,
            width: widget.isActive ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Заголовок: назва моделі + крок пайплайну + used/max ----
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: usageColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: usageColor.withValues(alpha: 0.4), blurRadius: 4, spreadRadius: 1),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.step.displayName,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: usageColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$used/$maxLimit',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _labeledBar(
              'Limit',
              _segmentBar(
                active: _limitSegmentsActive,
                total: _limitSegmentsTotal,
                colorOf: (_) => usageColor,
              ),
            ),

            const SizedBox(height: 8),

            // ---- Швидкість ----
            _labeledBar(
              'Speed',
              _segmentBar(
                active: _speedSegmentsActive,
                total: 4,
                colorOf: (_) => Colors.blue,
              ),
            ),

            const SizedBox(height: 8),

            _labeledBar(
              'Power',
              _segmentBar(
                active: _qualitySegmentsActive,
                total: 4,
                colorOf: (i) => _qualityColors[i],
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.bottomRight,
              child: _streamingToggle(),
            ),
          ],
        ),
      ),
    );
  }
}