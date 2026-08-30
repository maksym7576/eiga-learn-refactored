import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/providers/FlickManagerState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'phraseCardWidget.dart';

class PhraseListNotFullScreenWidget extends ConsumerStatefulWidget {
  const PhraseListNotFullScreenWidget({super.key});

  @override
  ConsumerState<PhraseListNotFullScreenWidget> createState() =>
      _PhraseListNotFullScreenWidgetState();
}

class _PhraseListNotFullScreenWidgetState
    extends ConsumerState<PhraseListNotFullScreenWidget> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  int _lastActiveIndex = -1;

  Duration _toDuration(DateTime dateTime) {
    return Duration(
      hours: dateTime.hour,
      minutes: dateTime.minute,
      seconds: dateTime.second,
      milliseconds: dateTime.millisecond,
    );
  }

  void _scrollToIndex(int index) {
    if (!_itemScrollController.isAttached) return;
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: 0.2,
    );
  }

  int _findActiveIndex(List phrases, Duration currentTime) {
    return phrases.indexWhere((phrase) {
      final start = _toDuration(phrase.startTime!);
      final end = _toDuration(phrase.endTime!);
      return currentTime >= start && currentTime < end;
    });
  }

  Set<int> _findFinishedIndexes(List phrases, Duration currentTime) {
    final finished = <int>{};
    for (var i = 0; i < phrases.length; i++) {
      if (currentTime >= _toDuration(phrases[i].endTime!)) {
        finished.add(i);
      }
    }
    return finished;
  }

  void _maybeAutoScroll(bool enabled, int activeIndex) {
    if (!enabled || activeIndex == -1 || activeIndex == _lastActiveIndex) {
      return;
    }
    _lastActiveIndex = activeIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToIndex(activeIndex));
  }

  bool _onUserScroll(UserScrollNotification notification) {
    if (notification.direction != ScrollDirection.idle &&
        ref.read(autoScrollProvider)) {
      ref.read(autoScrollProvider.notifier).disable();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final id = ref.watch(playerIdProvider);
    final currentTime = ref.watch(playerTimeProvider);
    final isAutoScrollEnabled = ref.watch(autoScrollProvider);
    final phraseAsync = ref.watch(phraseListProvider(id!));

    return phraseAsync.when(
      data: (phrases) => _buildList(
        phrases: phrases,
        currentTime: currentTime,
        isAutoScrollEnabled: isAutoScrollEnabled,
      ),
      error: (e, st) => Text('Error: $e'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildList({
    required List phrases,
    required Duration currentTime,
    required bool isAutoScrollEnabled,
  }) {
    final activeIndex = _findActiveIndex(phrases, currentTime);
    final finishedIndexes = _findFinishedIndexes(phrases, currentTime);

    _maybeAutoScroll(isAutoScrollEnabled, activeIndex);

    return NotificationListener<UserScrollNotification>(
      onNotification: _onUserScroll,
      child: ScrollablePositionedList.builder(
        itemScrollController: _itemScrollController,
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          final phrase = phrases[index];
          return PhraseCardWidget(
            phrase: phrase,
            isActive: index == activeIndex,
            isFinished: finishedIndexes.contains(index),
            onTap: () {
              if (index == activeIndex) {
                final manager = ref.read(flickManagerProvider).flickManager;
                final isPlaying = manager?.flickVideoManager?.isPlaying ?? false;
                if (isPlaying) {
                  manager?.flickControlManager?.pause();
                } else {
                  manager?.flickControlManager?.play();
                }
              } else {
                ref.read(playerSeekProvider.notifier).state =
                    _toDuration(phrase.startTime!);
              }
            },
          );
        },
      ),
    );
  }
}