import 'package:flutter/material.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/ui/styles/phraseListStyles.dart';
import 'phraseTranslatedWidget.dart';
import 'phraseNotTranslatedWidget.dart';

class PhraseCardWidget extends StatelessWidget {
  final PhraseObject phrase;
  final bool isActive;
  final bool isFinished;
  final VoidCallback onTap;

  const PhraseCardWidget({
    super.key,
    required this.phrase,
    required this.isActive,
    required this.isFinished,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: PhraseListStyles.cardMarginVertical,
          horizontal: PhraseListStyles.cardMarginHorizontal,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Колонка часу (Vertical Ruler Layout)
              _buildTimeRulerColumn(),
              const SizedBox(width: 6),
              // 2. Основна картка з текстом
              Expanded(
                child: _buildPhraseContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRulerColumn() {
    final start = phrase.startTime;
    if (start == null) return const SizedBox(width: PhraseListStyles.timeColumnWidth);

    final h = start.hour;
    final m = start.minute;
    final s = start.second;

    return Container(
      width: PhraseListStyles.timeColumnWidth,
      decoration: BoxDecoration(
        color: isActive 
            ? PhraseListStyles.timeColumnActiveBackground.withValues(alpha: 0.9)
            : PhraseListStyles.timeColumnBackground.withValues(alpha: isFinished ? 0.4 : 0.6),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(PhraseListStyles.cardBorderRadius),
          bottomLeft: Radius.circular(PhraseListStyles.cardBorderRadius),
        ),
        border: Border(
          right: BorderSide(
            color: isActive 
                ? PhraseListStyles.primaryColor.withValues(alpha: 0.2)
                : PhraseListStyles.primaryColor.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(right: 4, top: 4, bottom: 4), 
      child: Opacity(
        opacity: isFinished ? 0.6 : 1.0,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Години (якщо є) зверху
          h > 0
              ? Text(
                  '${h}h',
                  style: PhraseListStyles.getTimeTextStyle().copyWith(
                    fontSize: PhraseListStyles.fontSizeTimeTertiary,
                    fontWeight: FontWeight.w900,
                  ),
                )
              : const SizedBox(height: 8), // Заглушка, щоб не "пливло" вгору занадто сильно
          
          // 2. Хвилини (в центрі, найбільші)
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              '${m.toString().padLeft(2, '0')}m',
              style: PhraseListStyles.getTimeTextStyle().copyWith(
                fontSize: PhraseListStyles.fontSizeTimePrimary,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
          ),
          
          // 3. Секунди (знизу)
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              '${s.toString().padLeft(2, '0')}s',
              style: PhraseListStyles.getTimeTextStyle().copyWith(
                fontSize: PhraseListStyles.fontSizeTimeSecondary,
                color: PhraseListStyles.primaryColor.withValues(alpha: 0.6),
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildPhraseContent() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: PhraseListStyles.cardMinHeight,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: PhraseListStyles.cardPaddingVertical,
          horizontal: PhraseListStyles.cardPaddingHorizontal,
        ),
        decoration: PhraseListStyles.getCardDecoration(
          isFinished: isFinished,
          isActive: isActive,
        ),
        child: Opacity(
          opacity: isFinished ? 0.6 : 1.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: phrase.isTranslated
                    ? PhraseTranslatedWidget(key: ValueKey(phrase.id), phraseObject: phrase)
                    : PhraseNotTranslatedWidget(
                        key: ValueKey(phrase.id),
                        phraseObject: phrase,
                        isActive: isActive,
                      ),
              ),
              if (!phrase.isTranslated)
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 2),
                  child: _TranslationStatusWidget(phrase: phrase),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TranslationStatusWidget extends StatelessWidget {
  final PhraseObject phrase;

  const _TranslationStatusWidget({required this.phrase});

  @override
  Widget build(BuildContext context) {
    if (phrase.isTranslating) {
      return const SizedBox(
        width: PhraseListStyles.iconSizeLoading,
        height: PhraseListStyles.iconSizeLoading,
        child: CircularProgressIndicator(strokeWidth: 2, color: PhraseListStyles.primaryColor),
      );
    }

    return Tooltip(
      message: 'Not translated',
      child: Icon(
        Icons.translate,
        size: 14,
        color: PhraseListStyles.primaryColor.withValues(alpha: 0.3),
      ),
    );
  }
}
