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

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statItem(Icons.list_alt_rounded, const Color(0xFF64748B), totalCount.toString()),
                _divider(),
                _statItem(Icons.check_circle_rounded, const Color(0xFF059669), translatedCount.toString()),
                _divider(),
                _statItem(Icons.pending_rounded, const Color(0xFFD97706), translatingCount.toString()),
                _divider(),
                _statItem(Icons.hourglass_bottom_rounded, const Color(0xFF0284C7), notTranslatedCount.toString()),
              ],
            ),
          ),
        );
      },
      error: (error, stack) => const Icon(Icons.error_outline, size: 16, color: Colors.redAccent),
      loading: () => const Center(child: CupertinoActivityIndicator(radius: 6)),
    );
  }

  Widget _divider() => Container(
        height: 12,
        width: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: const Color(0xFF1E293B).withValues(alpha: 0.1),
      );

  Widget _statItem(IconData icon, Color color, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
