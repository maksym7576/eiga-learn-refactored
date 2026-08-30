import 'package:flutter/material.dart';

class VideoCardTheme {
  final bool isDark;

  VideoCardTheme({required this.isDark});

  factory VideoCardTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return VideoCardTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent (Neutral Indigo/Slate)
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;

  // Card Decoration
  Color get cardBackground => isDark ? const Color(0xFF2C2C2E) : Colors.white;
  Color get cardBorder => isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
  BorderRadius get borderRadius => BorderRadius.circular(18);
  
  List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Footer/Overlay
  Color get footerBackground => (isDark ? Colors.black : Colors.white).withValues(alpha: 0.85);
  
  // Text Styles (Semantic naming from AdditionalWindowTheme)
  Color get normalText => primaryAccent.withValues(alpha: 0.9);
  Color get mutedText => primaryAccent.withValues(alpha: 0.7);

  TextStyle get titleStyle => TextStyle(
    color: normalText,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  TextStyle get dateStyle => TextStyle(
    color: mutedText,
    fontSize: 11,
  );

  // Chips
  Color get chipBackground => primaryAccent.withValues(alpha: 0.12);
  Color get chipTextColor => primaryAccent.withValues(alpha: 0.9);
  Color get chipIconColor => primaryAccent.withValues(alpha: 0.7);

  TextStyle get chipTextStyle => TextStyle(
    color: chipTextColor,
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );

  // Thumbnail
  Color get thumbnailPlaceholderBackground => primaryAccent.withValues(alpha: 0.1);
  Color get thumbnailIconColor => primaryAccent.withValues(alpha: 0.7);

  // Menu
  Color get menuIconColor => primaryAccent;
  Color get menuBackground => (isDark ? Colors.grey[850] : Colors.white)!.withValues(alpha: 0.85);
}
