import 'package:flutter/material.dart';

class PhraseListTheme {
  final bool isDark;

  PhraseListTheme({required this.isDark});

  factory PhraseListTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return PhraseListTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;
  Color get successAccent => Colors.teal;

  // Backgrounds
  Color get cardBackground => isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF8FAFC);
  Color get activeCardBackground => isDark ? Colors.indigo.withValues(alpha: 0.15) : const Color(0xFFEEF2FF);
  Color get finishedCardBackground => isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9);

  Color get timeColumnBackground => isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0);
  Color get timeColumnActiveBackground => isDark ? Colors.indigo.withValues(alpha: 0.3) : const Color(0xFFC7D2FE);

  // Typography
  Color get normalText => isDark ? Colors.white : const Color(0xFF1E293B);
  Color get activeText => isDark ? Colors.white : const Color(0xFF111827);
  Color get mutedText => isDark ? Colors.white38 : const Color(0xFF64748B);
  Color get finishedText => isDark ? Colors.white24 : const Color(0xFF94A3B8);

  // Highlights
  Color get highlightWarm => const Color(0xFFF43F5E);
  Color get highlightGold => const Color(0xFFF59E0B);
  Color get highlightCool => const Color(0xFF0EA5E9);

  // Layout Constants
  double get cardBorderRadius => 12;
  double get timeColumnWidth => 44;
  
  List<BoxShadow> get activeShadow => [
    BoxShadow(
      color: primaryAccent.withValues(alpha: 0.15),
      blurRadius: 16,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    )
  ];

  // Helper Methods
  Color getCardColor({required bool isActive, required bool isFinished}) {
    if (isActive) return activeCardBackground;
    if (isFinished) return finishedCardBackground;
    return cardBackground;
  }

  TextStyle getPhraseStyle({required bool isActive, bool isFinished = false}) {
    return TextStyle(
      color: isActive ? activeText : (isFinished ? finishedText : normalText),
      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
      fontSize: 17,
      height: 1.3,
    );
  }
}
