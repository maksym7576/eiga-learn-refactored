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
    if (videoId == null) {
      return const SizedBox.shrink();
    }

    final phrasesAsync = ref.watch(phraseListProvider(videoId));

    return phrasesAsync.when(
      data: (phrases) {
        final totalCount = phrases.length;
        final translatedCount =
            phrases.where((phrase) => phrase.isTranslated).length;
        final translatingCount =
            phrases.where((phrase) => phrase.isTranslating).length;
        final notTranslatedCount =
            totalCount - translatedCount - translatingCount;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statItem(Icons.list, Colors.grey, totalCount.toString()),
            _statItem(Icons.check_circle_outline, Colors.green, translatedCount.toString()),
            _statItem(Icons.sync, Colors.orange, translatingCount.toString()),
            _statItem(Icons.hourglass_empty, Colors.blue, notTranslatedCount.toString()),
          ],
        );
      },
      error: (error, stack) => const Text(
        'Error loading stats',
        style: TextStyle(fontSize: 11, color: Colors.redAccent),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: CupertinoActivityIndicator(radius: 8),
      ),
    );
  }

  Widget _statItem(IconData icon, Color color, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }
}
