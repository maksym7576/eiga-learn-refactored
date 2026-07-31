import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/providers/subtitle_settings_provider.dart';
import 'package:eiga/providers/FlickManagerState.dart';
import 'package:flutter/material.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/fullScreenPhraseNotTranslatedWidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'fullScreenPhraseTranslatedWidget.dart';

class FullScreenPhraseWidget extends ConsumerWidget {
  final double bottomPadding;
  const FullScreenPhraseWidget({
    super.key,
    this.bottomPadding = 60.0,
  });

  Duration _toDuration(DateTime dateTime) {
    return Duration(
      hours: dateTime.hour,
      minutes: dateTime.minute,
      seconds: dateTime.second,
      milliseconds: dateTime.millisecond,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(playerIdProvider);
    if (id == null) return const SizedBox.shrink();

    final currentTime = ref.watch(playerTimeProvider);
    final phraseAsync = ref.watch(phraseListProvider(id));
    final subtitleSettings = ref.watch(subtitleSettingsNotifierProvider).value;
    final config = subtitleSettings?.fullScreen;

    return phraseAsync.when(
      data: (phrases) {
        final activePhrase = phrases.where((phrase) {
          if (phrase.startTime == null || phrase.endTime == null) return false;
          final start = _toDuration(phrase.startTime!);
          final end = _toDuration(phrase.endTime!);
          return currentTime >= start && currentTime < end;
        }).firstOrNull;

        if (activePhrase == null) return const SizedBox.shrink();

        final subtitleWidget = activePhrase.isTranslated
            ? FullScreenPhraseTranslatedWidget(
                key: ValueKey(activePhrase.id),
                phraseObject: activePhrase,
              )
            : FullScreenPhraseNotTranslatedWidget(
                key: ValueKey(activePhrase.id),
                phraseObject: activePhrase,
              );

        return LayoutBuilder(
          builder: (context, constraints) {
            final double offset = config?.groupOffset ?? 0.1;
            // groupOffset: 0.0 is bottom, 1.0 is top. 
            // We use Align with a calculated bottom padding or similar.
            
            return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: offset * constraints.maxHeight),
                child: GestureDetector(
                  onTap: () {
                    final manager = ref.read(flickManagerProvider).flickManager;
                    final isPlaying = manager?.flickVideoManager?.isPlaying ?? false;
                    if (isPlaying) {
                      manager?.flickControlManager?.pause();
                    } else {
                      manager?.flickControlManager?.play();
                    }
                  },
                  onTapDown: (_) {},
                  behavior: HitTestBehavior.opaque,
                  child: subtitleWidget,
                ),
              ),
            );
          },
        );
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
