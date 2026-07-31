import 'dart:ui';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/ui/widgets/playerWidgets/readingTypeSelectorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/subtitleSelectorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/timerShiftEditorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoInfoStatsWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dialogs/AppBottomSheet.dart';
import '../subtitles/AiRequestStatusWidget.dart';

class _IconPalette {
  static const Color subtitles = Color(0xFF4338CA); // Indigo 700
  static const Color reading = Color(0xFFF59E0B); // Amber 500
  static const Color aiInsights = Color(0xFF0EA5E9); // Sky 500
  static const Color sync = Color(0xFF94A3B8); // Slate 400
}

class VideoSettingsNotFullScreenWidget extends ConsumerWidget {
  const VideoSettingsNotFullScreenWidget({
    super.key,
  });

  static const double _fullWidth = 320;
  static const double _minWidth = 140;
  static const double _minScale = 0.72;

  void _showTimeEditDialog(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.8,
      child: const TimeshiftEditorWidget(),
    );
  }

  void _showAiStatusDialog(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.6,
      child: const SingleChildScrollView(
        child: AiRequestStatusWidget(),
      ),
    );
  }

  void _showReadingTypeDialog(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.85,
      child: const ReadingTypeSelectorWidget(),
    );
  }

  void _showSubtitleSettingsDialog(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.85,
      child: const SubtitleSelectorWidget(),
    );
  }

  double _scaleForWidth(double width) {
    if (width >= _fullWidth) return 1.0;
    if (width <= _minWidth) return _minScale;
    final t = (width - _minWidth) / (_fullWidth - _minWidth);
    return _minScale + (1.0 - _minScale) * t;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitlesEnabled = ref.watch(autoScrollProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = _scaleForWidth(constraints.maxWidth);

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 50),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurpleAccent.withValues(alpha: 0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: _buildCompactLayout(context, ref, subtitlesEnabled, scale),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactLayout(
      BuildContext context,
      WidgetRef ref,
      bool subtitlesEnabled,
      double scale,
      ) {
    return Row(
      children: [
        _CompactActionChip(
          onTap: () => ref.read(autoScrollProvider.notifier).toggle(),
          icon: subtitlesEnabled
              ? Icons.closed_caption_rounded
              : Icons.closed_caption_disabled_rounded,
          label: subtitlesEnabled ? 'CC ON' : 'CC OFF',
          isActive: subtitlesEnabled,
          scale: scale,
          color: _IconPalette.subtitles,
        ),

        SizedBox(width: 8 * scale),

        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: const VideoInfoStatsWidget(),
          ),
        ),

        SizedBox(width: 4 * scale),

        _MoreSettingsButton(
          scale: scale,
          onSelected: (value) {
            if (value == 1) _showTimeEditDialog(context);
            if (value == 2) _showReadingTypeDialog(context);
            if (value == 3) _showAiStatusDialog(context);
            if (value == 4) _showSubtitleSettingsDialog(context);
          },
        ),
      ],
    );
  }
}

/// Кнопка "більше налаштувань" — власна кругла скляна капсула замість
/// голої іконки, щоб вона читалась як окремий, тапабельний елемент,
/// а не як прикраса поруч зі списком статистики.
class _MoreSettingsButton extends StatelessWidget {
  final double scale;
  final ValueChanged<int> onSelected;

  const _MoreSettingsButton({
    required this.scale,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'More settings',
      offset: const Offset(0, 44),
      color: Colors.deepPurple[50],
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.deepPurpleAccent.withValues(alpha: 0.1)),
      ),
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) => [
        _menuItem(
          value: 2,
          icon: Icons.menu_book_rounded,
          color: _IconPalette.reading,
          label: 'Reading settings',
        ),
        _menuItem(
          value: 4,
          icon: Icons.subtitles_rounded,
          color: _IconPalette.subtitles,
          label: 'Subtitle display',
        ),
        _menuItem(
          value: 3,
          icon: Icons.psychology_alt_rounded,
          color: _IconPalette.aiInsights,
          label: 'AI insights',
        ),
        const PopupMenuDivider(height: 9),
        _menuItem(
          value: 1,
          icon: Icons.history_toggle_off_rounded,
          color: _IconPalette.sync,
          label: 'Sync subtitles',
        ),
      ],
      child: Container(
        width: 34 * scale,
        height: 34 * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.04),
          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        ),
        child: Icon(
          Icons.tune_rounded,
          size: 18 * scale,
          color: const Color(0xFF1E293B).withValues(alpha: 0.8),
        ),
      ),
    );
  }

  PopupMenuItem<int> _menuItem({
    required int value,
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return PopupMenuItem(
      value: value,
      height: 44,
      child: Row(
        children: [
          // Іконка-бейдж: м'який кольоровий фон замість голої іконки —
          // сучасний патерн (iOS Settings / Notion), краще читається в списку.
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactActionChip extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final bool isActive;
  final double scale;
  final Color color;

  const _CompactActionChip({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.scale,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: (10 * scale).clamp(6, 12),
          vertical: 6 * scale,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? color
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : Colors.black.withValues(alpha: 0.08),
            width: 1.2,
          ),
          // Легке світіння тільки в активному стані — дає іконці "вагу"
          // без того, щоб панель виглядала перевантаженою.
          boxShadow: isActive
              ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18 * scale,
              color: isActive ? Colors.white : const Color(0xFF1E293B).withValues(alpha: 0.65),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11 * scale,
                    color: isActive ? Colors.white : const Color(0xFF1E293B).withValues(alpha: 0.75),
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}