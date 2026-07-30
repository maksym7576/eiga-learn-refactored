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
              backgroundColor: Colors.deepPurpleAccent,
            ),
          );
          Navigator.of(context).pop();
          onComplete?.call();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.deepPurple[300]),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  formatDuration(totalDuration),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        _buildUnitChip('Hours', TimeUnit.hours, activeUnit),
                        const SizedBox(width: 6),
                        _buildUnitChip('Minutes', TimeUnit.minutes, activeUnit),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUnitChip('Seconds', TimeUnit.seconds, activeUnit),
                        const SizedBox(width: 6),
                        _buildUnitChip('MS', TimeUnit.milliseconds, activeUnit),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                Text(
                  '${activeUnit.value.name}: ${getActiveValue().toInt()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 12),

                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    activeTrackColor: Colors.deepPurpleAccent,
                    inactiveTrackColor: Colors.deepPurple[100],
                    thumbColor: Colors.deepPurpleAccent,
                  ),
                  child: Slider(
                    value: getActiveValue(),
                    min: getMinLimit(),
                    max: getMaxLimit(),
                    divisions: (getMaxLimit() - getMinLimit()).toInt(),
                    label: getActiveValue().toInt().toString(),
                    onChanged: updateActiveValue,
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => updateActiveValue(0),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.deepPurpleAccent,
                  ),
                  child: const Text('Reset', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: isLoading.value ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: isLoading.value ? null : applyTimeshift,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: isLoading.value
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text('Apply'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnitChip(String label, TimeUnit unit, ValueNotifier<TimeUnit> activeUnitState) {
    final isSelected = activeUnitState.value == unit;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => activeUnitState.value = unit,
      selectedColor: Colors.deepPurple[100],
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.deepPurpleAccent : Colors.transparent,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.deepPurpleAccent : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}