import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/ui/widgets/playerWidgets/readingTypeSelectorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/timerShiftEditorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoInfoStatsWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dialogs/AppBottomSheet.dart';
import '../subtitles/AiRequestStatusWidget.dart';

class VideoSettingsNotFullScreenWidget extends ConsumerWidget {
  final bool isExpanded;
  
  const VideoSettingsNotFullScreenWidget({
    super.key,
    this.isExpanded = false,
  });

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitlesEnabled = ref.watch(autoScrollProvider);

    return Container(
      width: double.infinity,
      constraints: isExpanded ? null : const BoxConstraints(maxHeight: 60),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: isExpanded 
            ? _buildExpandedLayout(context, ref, subtitlesEnabled)
            : LayoutBuilder(
                builder: (context, constraints) => _buildCompactLayout(
                  context, 
                  ref, 
                  subtitlesEnabled, 
                  constraints.maxWidth,
                ),
              ),
      ),
    );
  }

  Widget _buildCompactLayout(BuildContext context, WidgetRef ref, bool subtitlesEnabled, double width) {
    final isWide = width > 450;
    final isVeryWide = width > 600;

    return Row(
      children: [
        // Subtitle Toggle
        _CompactActionChip(
          onTap: () => ref.read(autoScrollProvider.notifier).toggle(),
          icon: subtitlesEnabled ? Icons.subtitles : Icons.subtitles_off,
          label: subtitlesEnabled ? 'Subtitles' : 'OFF',
          isActive: subtitlesEnabled,
          color: Colors.deepPurpleAccent,
        ),
        
        const SizedBox(width: 12),
        
        // AI Status (Pull out if wide)
        if (isWide) ...[
          _CompactActionChip(
            onTap: () => _showAiStatusDialog(context),
            icon: Icons.auto_awesome,
            label: 'AI',
            isActive: false,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 12),
        ],

        // Reading Settings (Pull out if very wide)
        if (isVeryWide) ...[
          _CompactActionChip(
            onTap: () => _showReadingTypeDialog(context),
            icon: Icons.menu_book,
            label: 'Reading',
            isActive: false,
            color: Colors.orangeAccent,
          ),
          const SizedBox(width: 12),
        ],

        // Video Stats (Compact)
        const Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: VideoInfoStatsWidget(),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // More Settings Menu
        PopupMenuButton<int>(
          icon: Icon(Icons.more_horiz, size: 24, color: Colors.grey[700]),
          padding: EdgeInsets.zero,
          onSelected: (value) {
            if (value == 1) _showTimeEditDialog(context);
            if (value == 2) _showReadingTypeDialog(context);
            if (value == 3) _showAiStatusDialog(context);
          },
          itemBuilder: (context) => [
            if (!isVeryWide)
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.menu_book, size: 20, color: Colors.deepPurpleAccent),
                    SizedBox(width: 12),
                    Text('Reading Settings', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            if (!isWide)
              const PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 20, color: Colors.deepPurpleAccent),
                    SizedBox(width: 12),
                    Text('AI Status', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Icon(Icons.edit_calendar, size: 20, color: Colors.black54),
                  SizedBox(width: 12),
                  Text('Edit Subtitle Time', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedLayout(BuildContext context, WidgetRef ref, bool subtitlesEnabled) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Рядок 1: Основні перемикачі
          Row(
            children: [
              Expanded(
                child: _CompactActionChip(
                  onTap: () => ref.read(autoScrollProvider.notifier).toggle(),
                  icon: subtitlesEnabled ? Icons.subtitles : Icons.subtitles_off,
                  label: subtitlesEnabled ? 'Subtitles ON' : 'Subtitles OFF',
                  isActive: subtitlesEnabled,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CompactActionChip(
                  onTap: () => _showReadingTypeDialog(context),
                  icon: Icons.menu_book,
                  label: 'Reading Mode',
                  isActive: false,
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Рядок 2: Додаткові інструменти
          Row(
            children: [
              Expanded(
                child: _CompactActionChip(
                  onTap: () => _showAiStatusDialog(context),
                  icon: Icons.auto_awesome,
                  label: 'AI Insights',
                  isActive: false,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CompactActionChip(
                  onTap: () => _showTimeEditDialog(context),
                  icon: Icons.edit_calendar,
                  label: 'Adjust Time',
                  isActive: false,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Статистика на всю ширину
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: const VideoInfoStatsWidget(),
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
  final Color color;

  const _CompactActionChip({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Дозволяємо кнопці займати мінімум місця, якщо вона не в Expanded
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
