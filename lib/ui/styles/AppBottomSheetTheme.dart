import 'package:flutter/material.dart';

class AppBottomSheetTheme {
  final bool isDark;

  AppBottomSheetTheme({required this.isDark});

  factory AppBottomSheetTheme.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppBottomSheetTheme(isDark: brightness == Brightness.dark);
  }

  // Central Accent
  Color get selectionAccentColor => isDark ? Colors.white : Colors.black;

  // General colors
  Color get backgroundColor => isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get barrierColor => Colors.black.withValues(alpha: 0.5);
  Color get dividerColor => isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
  
  BorderRadius get borderRadius => const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  List<BoxShadow> get shadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 10,
      spreadRadius: 5,
    ),
  ];

  // Handle (Consistent with AdditionalWindowTheme)
  Color get handleColor => isDark ? Colors.white24 : Colors.black12;
  double get handleWidth => 36;
  double get handleHeight => 4;
  double get handleRadius => 2;
  EdgeInsets get handlePadding => const EdgeInsets.only(top: 8, bottom: 8);

  // Transitions
  Duration get transitionDuration => const Duration(milliseconds: 300);
  Duration get snapDuration => const Duration(milliseconds: 200);
}
