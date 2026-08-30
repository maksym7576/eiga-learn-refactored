import 'package:eiga/ui/styles/PlayerSettingsTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/providers/servicesProviders.dart';
import '../../../providers/videoDataProviders.dart';

enum TimeUnit { hours, minutes, seconds, milliseconds }

class TimeshiftEditorWidget extends HookConsumerWidget {
  final VoidCallback? onComplete;

  const TimeshiftEditorWidget({
    super.key,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = PlayerSettingsTheme.of(context);
    final hours = useState<double>(0);
    final minutes = useState<double>(0);
    final seconds = useState<double>(0);
    final ms = useState<double>(0);

    final activeUnit = useState<TimeUnit>(TimeUnit.seconds);
    final isLoading = useState<bool>(false);

    final phraseService = ref.read(phraseServiceProvider);
    final videoId = ref.watch(playerIdProvider);

    final totalDuration = Duration(
      hours: hours.value.toInt(),
      minutes: minutes.value.toInt(),
      seconds: seconds.value.toInt(),
      milliseconds: ms.value.toInt(),
    );

    String formatDuration(Duration d) {
      final isNegative = d.isNegative;
      final absD = d.abs();
      final sign = isNegative ? '-' : '+';
      if (d.inMilliseconds == 0) return '0.0s';
      return '$sign ${absD.inHours}h ${absD.inMinutes % 60}m ${absD.inSeconds % 60}s ${absD.inMilliseconds % 1000}ms';
    }

    double getActiveValue() {
      switch (activeUnit.value) {
        case TimeUnit.hours: return hours.value;
        case TimeUnit.minutes: return minutes.value;
        case TimeUnit.seconds: return seconds.value;
        case TimeUnit.milliseconds: return ms.value;
      }
    }

    void updateActiveValue(double val) {
      switch (activeUnit.value) {
        case TimeUnit.hours: hours.value = val; break;
        case TimeUnit.minutes: minutes.value = val; break;
        case TimeUnit.seconds: seconds.value = val; break;
        case TimeUnit.milliseconds: ms.value = val; break;
      }
    }

    double getMinLimit() => activeUnit.value == TimeUnit.milliseconds ? -1000 : (activeUnit.value == TimeUnit.hours ? -12 : -60);
    double getMaxLimit() => activeUnit.value == TimeUnit.milliseconds ? 1000 : (activeUnit.value == TimeUnit.hours ? 12 : 60);

    Future<void> applyTimeshift() async {
      if (totalDuration.inMilliseconds == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select a time shift different from 0'), backgroundColor: Colors.orange),
        );
        return;
      }

      isLoading.value = true;
      try {
        if (videoId == null) throw Exception('VideoId not found');

        await phraseService.shiftPhrasesTimeByVideoId(videoId, totalDuration);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Time shifted successfully (${formatDuration(totalDuration)})'),
              backgroundColor: theme.primaryAccent,
            ),
          );
          Navigator.of(context).pop();
          onComplete?.call();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(
            'Edit Subtitle Time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: theme.primaryAccent,
            ),
          ),
          const SizedBox(height: 24),

          _buildGroup(
            theme: theme,
            title: 'Offset Preview',
            subtitle: 'The total time your subtitles will be shifted.',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                formatDuration(totalDuration),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: theme.primaryAccent,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildGroup(
            theme: theme,
            title: 'Adjustment Controls',
            subtitle: 'Select unit and slide to adjust the shift.',
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _UnitButton('Hours', TimeUnit.hours, activeUnit, theme),
                        const SizedBox(width: 8),
                        _UnitButton('Minutes', TimeUnit.minutes, activeUnit, theme),
                        const SizedBox(width: 8),
                        _UnitButton('Seconds', TimeUnit.seconds, activeUnit, theme),
                        const SizedBox(width: 8),
                        _UnitButton('MS', TimeUnit.milliseconds, activeUnit, theme),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                    activeTrackColor: theme.primaryAccent,
                    inactiveTrackColor: theme.primaryAccent.withValues(alpha: 0.1),
                    thumbColor: theme.primaryAccent,
                    valueIndicatorColor: theme.primaryAccent,
                    valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Slider(
                      value: getActiveValue(),
                      min: getMinLimit(),
                      max: getMaxLimit(),
                      divisions: (getMaxLimit() - getMinLimit()).toInt(),
                      label: getActiveValue().toInt().toString(),
                      onChanged: updateActiveValue,
                    ),
                  ),
                ),
                
                Text(
                  'Current ${activeUnit.value.name}: ${getActiveValue().toInt()}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.mutedText,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => updateActiveValue(0),
                  child: const Text('Reset this unit', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading.value ? null : applyTimeshift,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: isLoading.value
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Apply Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildGroup({
    required PlayerSettingsTheme theme,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.normalText,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.sectionBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.tileBorder,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitButton extends StatelessWidget {
  final String label;
  final TimeUnit unit;
  final ValueNotifier<TimeUnit> activeUnit;
  final PlayerSettingsTheme theme;

  const _UnitButton(this.label, this.unit, this.activeUnit, this.theme);

  @override
  Widget build(BuildContext context) {
    final isSelected = activeUnit.value == unit;
    final accent = theme.primaryAccent;

    return GestureDetector(
      onTap: () => activeUnit.value = unit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accent : theme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accent : theme.tileBorder,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : theme.normalText,
          ),
        ),
      ),
    );
  }
}
