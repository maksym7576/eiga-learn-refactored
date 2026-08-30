import 'package:flutter/material.dart';

class VideoUploadingTheme {
  final bool isDark;

  VideoUploadingTheme({required this.isDark});

  factory VideoUploadingTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return VideoUploadingTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent (Professional Indigo/Slate)
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;
  Color get primaryAccent => Colors.indigo;
  Color get accentAccent => Colors.indigoAccent;

  // General colors
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get titleColor => isDark ? Colors.white : Colors.black87;
  Color get subtitleColor => isDark ? Colors.white60 : Colors.black54;

  // Layout
  EdgeInsets get containerPadding => const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  EdgeInsets get actionsRowPadding => const EdgeInsets.symmetric(horizontal: 30);
  
  double get sectionGapSmall => 7;
  double get sectionGapMedium => 12;
  double get sectionGapLarge => 16;
  double get bottomSpacer => 20;

  // Field Decoration
  Color get inputBorderColor => isDark ? Colors.white12 : Colors.black12;
  Color get focusedInputBorderColor => isDark ? Colors.white24 : Colors.black26;
  Color get inputLabelColor => primaryAccent;

  InputDecoration titleFieldDecoration() {
    return InputDecoration(
      labelText: 'Name',
      labelStyle: TextStyle(color: inputLabelColor),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentAccent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: inputLabelColor.withValues(alpha: 0.4)),
      ),
    );
  }

  // File Box Styles (SwipeableFileBox)
  Color get fileBoxBackground => isDark ? Colors.white.withValues(alpha: 0.03) : Colors.indigo.withValues(alpha: 0.02);
  Color get fileBoxActiveBackground => isDark ? primaryAccent.withValues(alpha: 0.15) : primaryAccent.withValues(alpha: 0.1);
  Color get fileBoxBorder => isDark ? Colors.white.withValues(alpha: 0.08) : Colors.indigo.withValues(alpha: 0.1);
  Color get fileBoxActiveBorder => primaryAccent.withValues(alpha: 0.6);
  
  List<BoxShadow> get fileBoxActiveShadow => [
    BoxShadow(
      color: primaryAccent.withValues(alpha: isDark ? 0.2 : 0.15),
      blurRadius: 16,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    )
  ];

  Color get fileBoxActiveIcon => primaryAccent;
  Color get fileBoxInactiveIcon => isDark ? Colors.white.withValues(alpha: 0.2) : Colors.indigo.withValues(alpha: 0.3);
  
  Color get fileBoxActiveText => isDark ? Colors.white.withValues(alpha: 0.9) : primaryAccent;
  Color get fileBoxInactiveText => isDark ? Colors.white.withValues(alpha: 0.35) : Colors.indigo.withValues(alpha: 0.4);

  // Button Styles
  TextStyle get buttonTextStyle => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );

  ButtonStyle cancelButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: isDark ? Colors.white70 : Colors.black87,
      side: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  ButtonStyle submitButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    );
  }
}
