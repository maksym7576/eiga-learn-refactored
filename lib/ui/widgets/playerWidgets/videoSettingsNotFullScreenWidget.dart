import 'dart:ui';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/ui/styles/PlayerSettingsTheme.dart';
import 'package:eiga/ui/widgets/playerWidgets/readingTypeSelectorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/subtitleSelectorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/timerShiftEditorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoInfoStatsWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dialogs/AppBottomSheet.dart';
import '../subtitles/AiRequestStatusWidget.dart';

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
    final theme = PlayerSettingsTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = _scaleForWidth(constraints.maxWidth);

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 52),
              decoration: BoxDecoration(
                color: theme.barBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.barBorder, width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: _buildCompactLayout(context, ref, subtitlesEnabled, scale, theme),
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
      PlayerSettingsTheme theme,
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
          activeColor: theme.iconSubtitles,
          theme: theme,
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
          theme: theme,
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

class _MoreSettingsButton extends StatelessWidget {
  final double scale;
  final ValueChanged<int> onSelected;
  final PlayerSettingsTheme theme;

  const _MoreSettingsButton({
    required this.scale,
    required this.onSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'More settings',
      offset: const Offset(0, 48),
      color: theme.backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 16,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.tileBorder, width: 1),
      ),
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) => [
        _menuItem(
          value: 2,
          icon: Icons.menu_book_rounded,
          color: theme.iconReading,
          label: 'Reading settings',
        ),
        _menuItem(
          value: 4,
          icon: Icons.subtitles_rounded,
          color: theme.iconSubtitles,
          label: 'Subtitle display',
        ),
        _menuItem(
          value: 3,
          icon: Icons.psychology_alt_rounded,
          color: theme.iconAiInsights,
          label: 'AI insights',
        ),
        const PopupMenuDivider(height: 12),
        _menuItem(
          value: 1,
          icon: Icons.history_toggle_off_rounded,
          color: theme.iconSync,
          label: 'Sync subtitles',
        ),
      ],
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36 * scale,
        height: 36 * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.actionButtonBackground,
          border: Border.all(color: theme.actionButtonBorder),
        ),
        child: Icon(
          Icons.tune_rounded,
          size: 20 * scale,
          color: theme.normalText.withValues(alpha: 0.9),
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
      height: 48,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.normalText,
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
  final Color activeColor;
  final PlayerSettingsTheme theme;

  const _CompactActionChip({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.scale,
    required this.activeColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: (12 * scale).clamp(8, 14),
          vertical: 6 * scale,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor
              : theme.chipInactiveBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor.withValues(alpha: 0.5) : theme.chipInactiveBorder,
            width: 1.2,
          ),
          boxShadow: isActive ? theme.chipActiveShadow : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 19 * scale,
              color: isActive ? Colors.white : theme.normalText.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12 * scale,
                    color: isActive ? Colors.white : theme.normalText.withValues(alpha: 0.8),
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    letterSpacing: 0.2,
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
