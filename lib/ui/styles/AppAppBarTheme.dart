import 'package:flutter/material.dart';

class AppAppBarTheme {
  final bool isDark;

  AppAppBarTheme({required this.isDark});

  factory AppAppBarTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppAppBarTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent (Neutral Indigo/Slate)
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;
  Color get secondaryAccent => isDark ? Colors.white38 : Colors.black38;

  // General colors
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : Colors.grey[50]!;
  Color get normalText => isDark ? Colors.white : Colors.black87;
  Color get mutedText => isDark ? Colors.white60 : Colors.black54;

  // Logo
  TextStyle get logoStyle => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: primaryAccent,
    letterSpacing: 1.2,
  );

  // Model Selector
  Color get selectorBackground => isDark ? Colors.white10 : Colors.grey.shade50;
  Color get selectorActiveBackground => primaryAccent.withValues(alpha: 0.08);
  Color get selectorBorder => primaryAccent.withValues(alpha: 0.3);
  Color get selectorActiveBorder => primaryAccent;

  List<BoxShadow> get selectorActiveShadow => [
    BoxShadow(
      color: primaryAccent.withValues(alpha: 0.15),
      blurRadius: 12,
      spreadRadius: 2,
    )
  ];

  // Indicator
  Color get indicatorColor => primaryAccent;
  List<BoxShadow> get indicatorShadow => [
    BoxShadow(
      color: primaryAccent.withValues(alpha: 0.4),
      blurRadius: 4,
      spreadRadius: 1,
    ),
  ];

  // Labels
  TextStyle get stepLabelStyle => TextStyle(
    fontSize: 9,
    color: secondaryAccent,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  TextStyle get modelNameStyle => TextStyle(
    fontSize: 13,
    color: normalText,
    fontWeight: FontWeight.w600,
  );

  // Badge
  Color get badgeBackground => primaryAccent.withValues(alpha: 0.08);
  TextStyle get badgeTextStyle => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: primaryAccent,
  );

  // Icons
  Color get iconColor => normalText;
}
