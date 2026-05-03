import 'dart:math';

import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/phraseNotTranslatedWidget.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/phraseTranslatedWidget.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

enum TranslationState { translated, translating, notTranslated }

class PhraseListNotFullScreenWidget extends ConsumerStatefulWidget {
  PhraseListNotFullScreenWidget({super.key});

  @override
  ConsumerState<PhraseListNotFullScreenWidget> createState() =>
      _PhraseListNotFullScreenWidgetState();
}

class _PhraseListNotFullScreenWidgetState
    extends ConsumerState<PhraseListNotFullScreenWidget> {
  late ItemScrollController itemScrollController;
  int lastActiveIndex = -1;

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final h = time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
  }

  Duration toDuration(DateTime dataTime) {
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        alignment: 0.2,
      );
    }
  }

  TranslationState _getTranslationState(PhraseObject phrase) {
    if (phrase.isTranslated) {
      return TranslationState.translated;
    } else if (phrase.isTranslating) {
      return TranslationState.translating;
    } else {
      return TranslationState.translated;
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
          final start = toDuration(phrase.startTime!);
          final end = toDuration(phrase.endTime!);
          return currentTime >= start && currentTime < end;
        });

        if (isAutoScrollEnabled &&
            activeIndex != -1 &&
            activeIndex != lastActiveIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToIndex(activeIndex);
          });
          lastActiveIndex = activeIndex;
        }

        final pastIndex = phrases
            .asMap()
            .entries
            .where((entry) {
              final end = toDuration(entry.value.endTime!);
              return currentTime >= end;
            })
            .map((entry) => entry.key)
            .toList();

        return NotificationListener(
          onNotification: (notification) {
            if (notification is UserScrollNotification) {
              if (notification.direction != ScrollDirection.idle) {
                if (ref.read(autoScrollProvider)) {
                  ref.read(autoScrollProvider.notifier).disable();
                }
              }
            }
            return false;
          },
          child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              final phrase = phrases[index];
              final isActive = index == activeIndex;
              final isFinished = pastIndex.contains(index);
              return InkWell(
                onTap: () {
                  final seekTime = toDuration(phrase.startTime!);

                  ref.read(playerSeekProvider.notifier).state = seekTime;
                },
                child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: isFinished
                      ? Colors.deepPurpleAccent.withOpacity(0.3)
                      : isActive
                      ? Colors.deepPurpleAccent.withOpacity(0.6)
                      : Colors.deepPurpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    phrase.isTranslated
                        ? PhraseTranslatedWidget(
                            key: ValueKey(phrase.id),
                            phraseObject: phrase,
                          )
                        : PhraseNotTranslatedWidget(
                            key: ValueKey(phrase.id),
                            phraseObject: phrase,
                            isActive: isActive,
                          ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              _formatTime(phrase.startTime),
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: Colors.deepPurpleAccent,
                            ),
                            Text(
                              _formatTime(phrase.endTime),
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (!phrase.isTranslated)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.deepPurpleAccent.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Not translated',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.deepPurpleAccent[400],
                                  ),
                                ),
                              ),

                            if (phrase.isTranslating)
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                ),
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
