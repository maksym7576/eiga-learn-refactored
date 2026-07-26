import 'package:flutter/material.dart';

class PhraseListStyles {
  // ========== Colors — фіолетово-бірюзова тема ==========
  // Фон карток
  static const Color surfaceInactive = Color(0xFFFCFBFF); // майже білий, ледь помітний фіолетовий відтінок
  static const Color surfaceActive   = Color(0xFFFFFFFF); // чисто білий — для активного
  static const Color surfaceFinished = Color(0xFFF5F2FB); // трохи світліший лавандовий, все ще близько до білого

  static const Color primaryColor = Color(0xFF4A2C82); // насичений фіолетовий
  static const Color accentColor  = Color(0xFF00BFA5); // бірюзовий — для рамки активної картки

  // Текст фрази (PhraseNotTranslatedWidget)
  static const Color textColorDark     = Color(0xFF2E1A47); // темно-фіолетовий — за замовчуванням
  static const Color textColorActive   = Color(0xFF1A0033); // майже чорно-фіолетовий — коли активне
  static const Color textColorInactive = Color(0xFFB8A9D4); // світлий фіолетовий, без сірого відтінку
  static const Color textColorFinished = Color(0xFFD1C4E8); // майже пастельний лавандовий — завершене

  // Текст слів/блоків (WordItem, BlocksSection)
  static const Color wordColorSelected   = Color(0xFF6A1B9A); // яскравий фіолетовий, жирний — виділене
  static const Color wordColorUnselectedOnLight = Color(0xFF3D2C52);
  static const Color wordColorUnselectedOnDark  = Color(0xFF3D2C52);

  // ========== Кольорова палітра для граматичного виділення ==========
  // Три чітко різні кольори за відтінком (тон + вага), а не лише сірим
  static const Color highlightWarm = Color(0xFFE64A19); // теплий коралово-оранжевий — категорія 1
  static const Color highlightGold = Color(0xFFFFB300); // янтарно-золотий — категорія 2
  static const Color highlightCool = Color(0xFF00ACC1); // холодний бірюзово-блакитний — категорія 3

  // ========== Opacity ==========
  static const double opacityLabel = 0.75;
  static const double opacityWord = 0.6;

  // ========== Card Spacing ==========
  static const double cardPaddingVertical = 8;
  static const double cardPaddingHorizontal = 10;
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
  static const double fontSizeTime = 16;
  static const double fontSizeLabel = 10;
  static const double fontSizeAdditionalWord = 12;
  static const double fontSizeMainWord = 18;
  static const double fontSizeBlock = 18;

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
      border: isActive ? Border.all(color: accentColor, width: 2) : null,
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

  static TextStyle getWordTextStyle({
    required bool isSelected,
    required bool isAdditional,
    bool cardIsActive = false,
  }) => TextStyle(
    fontSize: isAdditional ? fontSizeAdditionalWord : fontSizeMainWord,
    color: isSelected
        ? wordColorSelected
        : (cardIsActive ? wordColorUnselectedOnDark : wordColorUnselectedOnLight),
    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
    decoration: isSelected ? TextDecoration.underline : null,
    decorationThickness: 1.5,
  );

  static TextStyle getBlockTextStyle({
    required bool isSelected,
    bool cardIsActive = false,
  }) => TextStyle(
    color: isSelected
        ? wordColorSelected
        : (cardIsActive ? wordColorUnselectedOnDark : wordColorUnselectedOnLight),
    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
    fontSize: fontSizeBlock,
    decoration: isSelected ? TextDecoration.underline : null,
    decorationThickness: 1.5,
  );

  /// Стиль для тексту фрази
  static TextStyle getPhraseTextStyle({required bool isActive, bool isFinished = false}) => TextStyle(
    color: isActive
        ? textColorActive
        : (isFinished ? textColorFinished : textColorDark),
    fontWeight: FontWeight.w700,
  );

  static Border getLabelBorder() => Border.all(color: primaryColor.withOpacity(opacityLabel));

  /// Колір для граматичної категорії (0/1/2)
  static Color getHighlightColor(int categoryIndex) {
    switch (categoryIndex % 3) {
      case 0: return highlightWarm;
      case 1: return highlightGold;
      default: return highlightCool;
    }
  }
}