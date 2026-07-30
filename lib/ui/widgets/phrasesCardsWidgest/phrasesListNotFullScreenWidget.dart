import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../styles/phraseListStyles.dart';
import 'phraseCardWidget.dart';

class PhraseListNotFullScreenWidget extends ConsumerStatefulWidget {
  const PhraseListNotFullScreenWidget({super.key});

  @override
  ConsumerState<PhraseListNotFullScreenWidget> createState() =>
      _PhraseListNotFullScreenWidgetState();
}

class _PhraseListNotFullScreenWidgetState extends ConsumerState<PhraseListNotFullScreenWidget> {
  late ItemScrollController itemScrollController;
  int lastActiveIndex = -1;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
  }

  Duration _toDuration(DateTime dataTime) {
    return Duration(
      hours: dataTime.hour,
      minutes: dataTime.minute,
      seconds: dataTime.second,
      milliseconds: dataTime.millisecond,
    );
  }

  void _scrollToIndex(int index) {
    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: index,
        duration: PhraseListStyles.durationScroll,
        curve: PhraseListStyles.curveScroll,
        alignment: PhraseListStyles.scrollAlignment,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ref.read(playerIdProvider);
    final currentTime = ref.watch(playerTimeProvider);
    final phraseAsync = ref.watch(phraseListProvider(id!));
    final isAutoScrollEnabled = ref.watch(autoScrollProvider);

    return phraseAsync.when(
      data: (phrases) {
        final activeIndex = phrases.indexWhere((phrase) {
          final start = _toDuration(phrase.startTime!);
          final end = _toDuration(phrase.endTime!);
          return currentTime >= start && currentTime < end;
        });

        if (isAutoScrollEnabled && activeIndex != -1 && activeIndex != lastActiveIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToIndex(activeIndex));
          lastActiveIndex = activeIndex;
        }

        final pastIndex = phrases.asMap().entries.where((entry) {
          return currentTime >= _toDuration(entry.value.endTime!);
        }).map((entry) => entry.key).toList();

        return NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction != ScrollDirection.idle && ref.read(autoScrollProvider)) {
              ref.read(autoScrollProvider.notifier).disable();
            }
            return false;
          },
          child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              final phrase = phrases[index];
              return PhraseCardWidget(
                phrase: phrase,
                isActive: index == activeIndex,
                isFinished: pastIndex.contains(index),
                onTap: () {
                  ref.read(playerSeekProvider.notifier).state = _toDuration(phrase.startTime!);
                },
              );
            },
          ),
        );
      },
      error: (e, st) => Text('Error: $e'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
