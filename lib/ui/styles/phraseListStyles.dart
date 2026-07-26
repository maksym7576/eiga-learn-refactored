import 'package:flutter/material.dart';

class PhraseListStyles {
  // ========== Colors — чорно-біла тема ==========
  // Фон карток
  static const Color surfaceInactive = Color(0xFFF5F5F5); // світло-сірий
  static const Color surfaceActive   = Color(0xFFFFFFFF); // чисто білий — для активного
  static const Color surfaceFinished = Color(0xFFE8E8E8); // трохи темніший за inactive

  static const Color primaryColor = Color(0xFF1A1A1A); // майже чорний — замість фіолетового
  static const Color accentColor  = Color(0xFF404040); // темно-сірий — замість бірюзового

  // Текст фрази (PhraseNotTranslatedWidget)
  static const Color textColorDark     = Color(0xFF1A1A1A); // майже чорний — за замовчуванням
  static const Color textColorActive   = Color(0xFF000000); // чистий чорний — коли активне
  static const Color textColorInactive = Color(0xFF8A8A8A); // сірий — коли не активне
  static const Color textColorFinished = Color(0xFFA0A0A0); // світліший сірий — завершене

  // Текст слів/блоків (WordItem, BlocksSection)
  static const Color wordColorSelected   = Color(0xFF000000); // чорний, жирний — виділене
  static const Color wordColorUnselectedOnLight = Color(0xFF2B2B2B);
  static const Color wordColorUnselectedOnDark  = Color(0xFF2B2B2B);

  // ========== Монохромна "трикольна" палітра для граматичного виділення ==========
  // Розрізняються не тоном (кольору немає), а відтінком сірого + вагою + підкресленням,
  // щоб три категорії лишались візуально відмінними одна від одної
  static const Color highlightWarm = Color(0xFF000000); // чорний, найтемніший — категорія 1
  static const Color highlightGold = Color(0xFF5A5A5A); // середньо-сірий — категорія 2
  static const Color highlightCool = Color(0xFF8A8A8A); // світліший сірий — категорія 3

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

  /// Колір + стиль підкреслення для граматичної категорії (0/1/2)
  static Color getHighlightColor(int categoryIndex) {
    switch (categoryIndex % 3) {
      case 0: return highlightWarm;
      case 1: return highlightGold;
      default: return highlightCool;
    }
  }
}