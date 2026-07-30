import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/ui/widgets/playerWidgets/readingTypeSelectorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/timerShiftEditorWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoInfoStatsWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dialogs/AppBottomSheet.dart';
import '../subtitles/AiRequestStatusWidget.dart';

class VideoSettingsNotFullScreenWidget extends ConsumerWidget {
  const VideoSettingsNotFullScreenWidget({super.key});

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
      height: 44, // Fixed height to prevent vertical expansion
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // Subtitle Toggle
              _CompactActionChip(
                onTap: () => ref.read(autoScrollProvider.notifier).toggle(),
                icon: subtitlesEnabled ? Icons.subtitles : Icons.subtitles_off,
                label: subtitlesEnabled ? 'ON' : 'OFF',
                isActive: subtitlesEnabled,
              ),
              const SizedBox(width: 16),
              
              // Video Stats (Compact)
              const VideoInfoStatsWidget(),
              
              const SizedBox(width: 8),
              
              // More Settings Menu
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert, size: 22, color: Colors.deepPurpleAccent),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 1) _showTimeEditDialog(context);
                  if (value == 2) _showReadingTypeDialog(context);
                  if (value == 3) _showAiStatusDialog(context);
                },
                itemBuilder: (context) => [
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
          ),
        ),
      ),
    );
  }
}

class _CompactActionChip extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final bool isActive;

  const _CompactActionChip({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isActive 
              ? Colors.deepPurpleAccent 
              : Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
