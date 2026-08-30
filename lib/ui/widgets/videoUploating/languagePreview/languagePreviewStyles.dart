import 'package:flutter/material.dart';

class LanguagePreviewTheme {
  final bool isDark;

  LanguagePreviewTheme({required this.isDark});

  factory LanguagePreviewTheme.of(BuildContext context) {
    // Поки що можемо вручну керувати, або брати з контексту
    final brightness = Theme.of(context).brightness;
    return LanguagePreviewTheme(isDark: brightness == Brightness.dark);
  }

  // Загальні кольори
  Color get backgroundColor => isDark ? const Color(0xFF121212) : Colors.white;
  Color get titleColor => isDark ? Colors.white : Colors.deepPurpleAccent;
  Color get subtitleColor => isDark ? Colors.white54 : Colors.black.withValues(alpha: 0.4);
  Color get closeIconColor => isDark ? Colors.white70 : Colors.black87;

  // Стилі табів (Original/Translation)
  Color get tabSwitcherBackground => isDark ? Colors.white.withValues(alpha: 0.08) : Colors.deepPurple.shade50.withValues(alpha: 0.5);
  Color get activeTabBackground => isDark ? Colors.white : Colors.deepPurpleAccent;
  Color get activeTabText => isDark ? Colors.black : Colors.white;
  Color get inactiveTabBackground => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent;
  Color get inactiveTabText => isDark ? Colors.white.withValues(alpha: 0.4) : Colors.deepPurpleAccent.withValues(alpha: 0.6);

  // Стилі карток мов (LanguageWidget)
  Color get cardBackground => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
  Color get cardBorder => isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);
  Color get selectedCardBackground => isDark 
      ? const Color(0xFF0D47A1).withValues(alpha: 0.6) 
      : Colors.deepPurpleAccent.withValues(alpha: 0.1);
  Color get selectedCardBorder => isDark ? Colors.blueAccent : Colors.deepPurpleAccent;
  Color get selectedText => isDark ? Colors.blue.shade100 : Colors.deepPurpleAccent;
  Color get normalText => isDark ? Colors.white70 : Colors.black87;
  Color get occupiedText => isDark ? Colors.white24 : Colors.grey;
  Color get checkIconColor => isDark ? Colors.blueAccent : Colors.deepPurpleAccent;
  Color get lockIconColor => isDark ? Colors.white24 : Colors.grey;
  Color get unselectedCircleBorder => isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1);
}
