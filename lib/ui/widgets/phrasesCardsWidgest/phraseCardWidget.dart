import 'package:flutter/material.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/ui/styles/PhraseListTheme.dart';
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
    final theme = PhraseListTheme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 8,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Колонка часу (Vertical Ruler Layout)
              _buildTimeRulerColumn(theme),
              const SizedBox(width: 6),
              // 2. Основна картка з текстом
              Expanded(
                child: _buildPhraseContent(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRulerColumn(PhraseListTheme theme) {
    final start = phrase.startTime;
    if (start == null) return SizedBox(width: theme.timeColumnWidth);

    final h = start.hour;
    final m = start.minute;
    final s = start.second;

    return Container(
      width: theme.timeColumnWidth,
      decoration: BoxDecoration(
        color: isActive 
            ? theme.timeColumnActiveBackground.withValues(alpha: 0.9)
            : theme.timeColumnBackground.withValues(alpha: isFinished ? 0.4 : 0.6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.cardBorderRadius),
          bottomLeft: Radius.circular(theme.cardBorderRadius),
        ),
        border: Border(
          right: BorderSide(
            color: isActive 
                ? theme.primaryAccent.withValues(alpha: 0.2)
                : theme.primaryAccent.withValues(alpha: 0.05),
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
                  style: TextStyle(
                    color: theme.primaryAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                )
              : const SizedBox(height: 8), 
          
          // 2. Хвилини (в центрі, найбільші)
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              '${m.toString().padLeft(2, '0')}m',
              style: TextStyle(
                color: theme.primaryAccent,
                fontSize: 18,
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
              style: TextStyle(
                color: theme.primaryAccent.withValues(alpha: 0.6),
                fontSize: 12,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildPhraseContent(PhraseListTheme theme) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 60,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: theme.getCardColor(isActive: isActive, isFinished: isFinished),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(theme.cardBorderRadius),
            bottomRight: Radius.circular(theme.cardBorderRadius),
          ),
          boxShadow: isActive ? theme.activeShadow : null,
          border: Border.all(
            color: isActive
                ? theme.primaryAccent.withValues(alpha: 0.3)
                : (isFinished ? Colors.transparent : Colors.black.withValues(alpha: 0.05)),
            width: isActive ? 1.5 : 0.5,
          ),
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
                  child: _TranslationStatusWidget(phrase: phrase, theme: theme),
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
  final PhraseListTheme theme;

  const _TranslationStatusWidget({required this.phrase, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (phrase.isTranslating) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: theme.primaryAccent),
      );
    }

    return Tooltip(
      message: 'Not translated',
      child: Icon(
        Icons.translate,
        size: 14,
        color: theme.primaryAccent.withValues(alpha: 0.3),
      ),
    );
  }
}
