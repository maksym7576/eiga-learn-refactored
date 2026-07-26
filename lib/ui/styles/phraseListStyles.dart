import 'package:flutter/material.dart';

class PhraseListStyles {
  // ========== Colors ==========
  static const Color primaryColor = Colors.deepPurpleAccent;
  static const Color textColorDark = Colors.black;
  static const Color textColorLight = Colors.white;

  // ========== Opacity ==========
  static const double opacityFinished = 0.3;
  static const double opacityActive = 0.5;
  static const double opacityInactive = 0.1;
  static const double opacityLabel = 0.7;
  static const double opacityWord = 0.7;

  // ========== Card Spacing ==========
  static const double cardPaddingVertical = 8;
  static const double cardPaddingHorizontal = 20;
  static const double cardMarginVertical = 4;
  static const double cardMarginHorizontal = 8;
  static const double cardBorderRadius = 8;

  // ========== Word/Block Spacing ==========
  static const double wordSpacing = 1.0;
  static const double wordRunSpacing = 5.0;
  static const double wordPadding = 2;
  static const double blockSectionSpacing = 4;
  static const double containerPadding = 6.0;
  static const double contentSpacing = 3;

  // ========== Label Spacing ==========
  static const double labelPaddingHorizontal = 6;
  static const double labelPaddingVertical = 2;
  static const double labelBorderRadius = 4;

  // ========== Font Sizes ==========
  static const double fontSizeTime = 14;
  static const double fontSizeLabel = 8;
  static const double fontSizeAdditionalWord = 8;
  static const double fontSizeMainWord = 14;
  static const double fontSizeBlock = 14;

  // ========== Icon Sizes ==========
  static const double iconSizeArrow = 14;
  static const double iconSizeLoading = 14;

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
    final opacity = isFinished ? opacityFinished : isActive ? opacityActive : opacityInactive;
    return primaryColor.withOpacity(opacity);
  }

  static BoxDecoration getCardDecoration({required bool isFinished, required bool isActive}) {
    return BoxDecoration(
      color: getCardBackgroundColor(isFinished: isFinished, isActive: isActive),
      borderRadius: BorderRadius.circular(cardBorderRadius),
    );
  }

  static TextStyle getTimeTextStyle() => const TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w700,
    fontSize: fontSizeTime,
  );

  static TextStyle getLabelTextStyle() => const TextStyle(
    fontSize: fontSizeLabel,
    color: primaryColor,
  );

  static TextStyle getWordTextStyle({required bool isSelected, required bool isAdditional}) => TextStyle(
    fontSize: isAdditional ? fontSizeAdditionalWord : fontSizeMainWord,
    color: isSelected ? Colors.deepPurple : primaryColor.withOpacity(opacityWord),
    fontWeight: FontWeight.bold,
  );

  static TextStyle getBlockTextStyle({required bool isSelected}) => TextStyle(
    color: isSelected ? Colors.deepPurple : primaryColor.withOpacity(opacityWord),
    fontWeight: FontWeight.bold,
    fontSize: fontSizeBlock,
  );

  static TextStyle getPhraseTextStyle({required bool isActive}) => TextStyle(
    color: isActive ? textColorLight : textColorDark,
    fontWeight: FontWeight.w700,
  );

  static Border getLabelBorder() => Border.all(color: primaryColor.withOpacity(opacityLabel));
}