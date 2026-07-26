import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/phraseNotTranslatedWidget.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/phraseTranslatedWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../styles/phraseListStyles.dart';

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
              return _PhraseCardItem(
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

class _PhraseCardItem extends StatelessWidget {
  final PhraseObject phrase;
  final bool isActive;
  final bool isFinished;
  final VoidCallback onTap;

  const _PhraseCardItem({
    required this.phrase,
    required this.isActive,
    required this.isFinished,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: PhraseListStyles.durationCardAnimation,
        margin: const EdgeInsets.symmetric(
          vertical: PhraseListStyles.cardMarginVertical,
          horizontal: PhraseListStyles.cardMarginHorizontal,
        ),
        // Якщо карточки досі завеликі, зменште cardPaddingVertical у файлі стилів (наприклад, до 8)
        padding: const EdgeInsets.symmetric(
          vertical: PhraseListStyles.cardPaddingVertical,
          horizontal: PhraseListStyles.cardPaddingHorizontal,
        ),
        decoration: PhraseListStyles.getCardDecoration(
          isFinished: isFinished,
          isActive: isActive,
        ),
        child: Column(
          // ГОЛОВНИЙ ФІКС: Розтягуємо контент, щоб він автоматично ставав по лівому краю
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            phrase.isTranslated
                ? PhraseTranslatedWidget(key: ValueKey(phrase.id), phraseObject: phrase)
                : PhraseNotTranslatedWidget(
              key: ValueKey(phrase.id),
              phraseObject: phrase,
              isActive: isActive,
            ),
            const SizedBox(height: PhraseListStyles.contentSpacing),
            _PhraseMetaRow(phrase: phrase),
          ],
        ),
      ),
    );
  }
}

class _PhraseMetaRow extends StatelessWidget {
  final PhraseObject phrase;

  const _PhraseMetaRow({required this.phrase});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TimeRangeWidget(
          startTime: phrase.startTime,
          endTime: phrase.endTime,
        ),
        _TranslationStatusWidget(phrase: phrase),
      ],
    );
  }
}

class _TimeRangeWidget extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? endTime;

  const _TimeRangeWidget({required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(PhraseListStyles.formatTime(startTime), style: PhraseListStyles.getTimeTextStyle()),
        const Icon(Icons.arrow_forward, size: PhraseListStyles.iconSizeArrow, color: PhraseListStyles.primaryColor),
        Text(PhraseListStyles.formatTime(endTime), style: PhraseListStyles.getTimeTextStyle()),
      ],
    );
  }
}

class _TranslationStatusWidget extends StatelessWidget {
  final PhraseObject phrase;

  const _TranslationStatusWidget({required this.phrase});

  @override
  Widget build(BuildContext context) {
    if (phrase.isTranslated || phrase.isTranslating) {
      return phrase.isTranslating
          ? const SizedBox(
        width: PhraseListStyles.iconSizeLoading,
        height: PhraseListStyles.iconSizeLoading,
        child: CircularProgressIndicator(strokeWidth: 2, color: PhraseListStyles.primaryColor),
      )
          : const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PhraseListStyles.labelPaddingHorizontal,
        vertical: PhraseListStyles.labelPaddingVertical,
      ),
      decoration: BoxDecoration(
        border: PhraseListStyles.getLabelBorder(),
        borderRadius: BorderRadius.circular(PhraseListStyles.labelBorderRadius),
      ),
      child: Text('Not translated', style: PhraseListStyles.getLabelTextStyle()),
    );
  }
}