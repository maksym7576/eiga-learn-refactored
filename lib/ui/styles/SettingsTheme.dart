import 'package:flutter/material.dart';

class SettingsTheme {
  final bool isDark;

  SettingsTheme({required this.isDark});

  factory SettingsTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return SettingsTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;

  // General colors
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get sectionBackground => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50;
  Color get cardBackground => isDark ? const Color(0xFF2C2C2E) : Colors.indigo.withValues(alpha: 0.04);
  Color get normalText => isDark ? Colors.white : Colors.black87;
  Color get mutedText => isDark ? Colors.white60 : Colors.black54;

  // Dialogs
  Color get dialogBackground => isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get dialogBorder => isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05);

  // Buttons
  ButtonStyle primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    );
  }

  ButtonStyle secondaryButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: isDark ? Colors.white70 : Colors.black87,
      side: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // API Key Card
  Color get apiKeyCardBorder => primaryAccent.withValues(alpha: 0.2);
  Color get apiKeyCardTitle => primaryAccent;
  Color get apiKeyCardSubtitle => primaryAccent.withValues(alpha: 0.6);
  Color get apiKeyInfoIconBackground => primaryAccent.withValues(alpha: 0.1);
  Color get apiKeyInfoIcon => primaryAccent;
}
