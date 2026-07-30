import 'package:flutter/material.dart';

class PhraseListStyles {
  // ========== Colors — Modern Slate & Indigo (Universal Professional) ==========
  // Backgrounds
  static const Color surfaceInactive = Color(0xFFF8FAFC); // Slate 50 - Neutral future
  static const Color surfaceActive   = Color(0xFFEEF2FF); // Indigo 50 - Soft highlight for current
  static const Color surfaceFinished = Color(0xFFF1F5F9); // Slate 100 - Muted past

  static const Color primaryColor = Color(0xFF4338CA); // Indigo 700 - Deep, professional indigo
  static const Color accentColor  = Color(0xFF10B981); // Emerald 500 - Refined success/active indicator
  
  static const Color timeColumnBackground = Color(0xFFE2E8F0); // Slate 200 - Clearly defined column
  static const Color timeColumnActiveBackground = Color(0xFFC7D2FE); // Indigo 200 - Highlighted active time

  // Typography
  static const Color textColorDark     = Color(0xFF1E293B); // Slate 800 - High legibility
  static const Color textColorActive   = Color(0xFF111827); // Slate 900 - Max contrast for active
  static const Color textColorInactive = Color(0xFF64748B); // Slate 500 - Upcoming context
  static const Color textColorFinished = Color(0xFF94A3B8); // Slate 400 - Muted past text

  // Text Selection / Interaction
  static const Color wordColorSelected   = Color(0xFF4338CA); // Same as primary for consistency
  static const Color wordColorUnselectedOnLight = Color(0xFF334155); // Slate 700
  static const Color wordColorUnselectedOnDark  = Color(0xFF1E293B); // Slate 800

  // Текст слів/блоків (WordItem, BlocksSection)

  // ========== Grammar Highlights (Balanced Harmony) ==========
  static const Color highlightWarm = Color(0xFFF43F5E); // Rose 500
  static const Color highlightGold = Color(0xFFF59E0B); // Amber 500
  static const Color highlightCool = Color(0xFF0EA5E9); // Sky 500

  // ========== Opacity ==========
  static const double opacityLabel = 0.75;
  static const double opacityWord = 0.6;

  // ========== Timeline Layout (Professional Layout) ==========
  static const double timeColumnWidth = 40.0; // Трохи збільшено, щоб одиниці (m, s) не переносились
  static const double cardMinHeight = 60.0;

  // ========== Card Spacing ==========
  static const double cardPaddingVertical = 6;
  static const double cardPaddingHorizontal = 10;
  static const double cardMarginVertical = 2; // Менші відступи між рядками шкали
  static const double cardMarginHorizontal = 8;
  static const double cardBorderRadius = 8;

  // ========== Word/Block Spacing ==========
  static const double wordSpacing = 0.0;
  static const double wordSpacingStandard = 6.0;
  static const double wordRunSpacing = 2.0;
  static const double wordPadding = 0.0;
  static const double blockSectionSpacing = 4;
  static const double containerPadding = 6.0;
  static const double contentSpacing = 3;

  // ========== Label Spacing ==========
  static const double labelPaddingHorizontal = 6;
  static const double labelPaddingVertical = 2;
  static const double labelBorderRadius = 4;

  // ========== Font Sizes ==========
  static const double fontSizeTime = 13;
  static const double fontSizeTimePrimary = 18;   // Хвилини (в центрі)
  static const double fontSizeTimeSecondary = 12; // Секунди (знизу)
  static const double fontSizeTimeTertiary = 9;   // Години (зверху)
  static const double fontSizeLabel = 9;
  static const double fontSizeAdditionalWord = 10; // Фурігана
  static const double fontSizeMainWord = 18;      // Компактний японський текст
  static const double fontSizeBlock = 14;         // Компактний переклад

  // ========== Icon Sizes ==========
  static const double iconSizeArrow = 16;
  static const double iconSizeLoading = 16;

  // ========== Animations ==========
  static const Duration durationCardAnimation = Duration(milliseconds: 200);
  static const Duration durationWordAnimation = Duration(milliseconds: 150);
  static const Duration durationScroll = Duration(milliseconds: 300);
  static const Curve curveScroll = Curves.easeInOutCubic;
  static const Curve curveWord = Curves.easeOut;

  // ========== Scroll ==========
  static const double scrollAlignment = 0.2;

  // ========== Helper Methods ==========

  static String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final h = time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  static Color getCardBackgroundColor({required bool isFinished, required bool isActive}) {
    if (isActive) return surfaceActive;
    if (isFinished) return surfaceFinished;
    return surfaceInactive;
  }

  static BoxDecoration getCardDecoration({required bool isFinished, required bool isActive}) {
    return BoxDecoration(
      color: getCardBackgroundColor(isFinished: isFinished, isActive: isActive),
      borderRadius: BorderRadius.circular(cardBorderRadius),
      boxShadow: isActive ? [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.15),
          blurRadius: 16,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        )
      ] : (isFinished ? null : [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        )
      ]),
      border: Border.all(
        color: isActive 
          ? primaryColor.withValues(alpha: 0.3) 
          : (isFinished ? Colors.transparent : Colors.black.withValues(alpha: 0.05)),
        width: isActive ? 2 : 1,
      ),
    );
  }

  static TextStyle getTimeTextStyle() => const TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextStyle getLabelTextStyle() => const TextStyle(
    fontSize: fontSizeLabel,
    color: primaryColor,
  );

  static TextStyle getWordTextStyle({
    required bool isSelected,
    required bool isAdditional,
    bool cardIsActive = false,
  }) => TextStyle(
    fontSize: isAdditional ? fontSizeAdditionalWord : fontSizeMainWord,
    color: isSelected
        ? wordColorSelected
        : (cardIsActive ? textColorActive : textColorDark),
    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
    decoration: isSelected ? TextDecoration.underline : null,
    decorationColor: accentColor,
    decorationThickness: 2.0,
    height: 1.2,
  );

  static TextStyle getBlockTextStyle({
    required bool isSelected,
    bool cardIsActive = false,
  }) => TextStyle(
    color: isSelected
        ? wordColorSelected
        : (cardIsActive ? textColorActive.withValues(alpha: 0.9) : textColorDark.withValues(alpha: 0.8)),
    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
    fontSize: fontSizeBlock,
    fontStyle: FontStyle.italic,
  );

  /// Стиль для тексту фрази
  static TextStyle getPhraseTextStyle({required bool isActive, bool isFinished = false}) => TextStyle(
    color: isActive
        ? textColorActive
        : (isFinished ? textColorFinished : textColorDark),
    fontWeight: FontWeight.w600,
    fontSize: fontSizeMainWord,
    height: 1.2,
  );

  static Border getLabelBorder() => Border.all(color: primaryColor.withValues(alpha: opacityLabel));

  /// Колір для граматичної категорії (0/1/2)
  static Color getHighlightColor(int categoryIndex) {
    switch (categoryIndex % 3) {
      case 0: return highlightWarm;
      case 1: return highlightGold;
      default: return highlightCool;
    }
  }
}