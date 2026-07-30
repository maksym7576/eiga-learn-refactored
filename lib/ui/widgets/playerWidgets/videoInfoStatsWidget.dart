import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoInfoStatsWidget extends ConsumerWidget {
  const VideoInfoStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoId = ref.watch(playerIdProvider);
    if (videoId == null) return const SizedBox.shrink();

    final phrasesAsync = ref.watch(phraseListProvider(videoId));

    return phrasesAsync.when(
      data: (phrases) {
        final total = phrases.length;
        final done = phrases.where((p) => p.isTranslated).length;
        final prog = phrases.where((p) => p.isTranslating).length;
        final left = total - done - prog;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CompactStat(
              icon: Icons.functions, 
              value: total.toString(), 
              color: Colors.deepPurpleAccent
            ),
            const SizedBox(width: 8),
            _CompactStat(
              icon: Icons.check_circle_outline, 
              value: done.toString(), 
              color: Colors.green
            ),
            const SizedBox(width: 8),
            _CompactStat(
              icon: Icons.sync, 
              value: prog.toString(), 
              color: Colors.orange
            ),
            const SizedBox(width: 8),
            _CompactStat(
              icon: Icons.hourglass_empty, 
              value: left.toString(), 
              color: Colors.blueGrey
            ),
          ],
        );
      },
      error: (_, __) => const Icon(Icons.error_outline, size: 16, color: Colors.red),
      loading: () => const CupertinoActivityIndicator(radius: 8),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _CompactStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
