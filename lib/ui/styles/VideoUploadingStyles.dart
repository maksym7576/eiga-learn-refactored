import 'package:flutter/material.dart';

/// Стилі та константи для [VideoUploadingWidget].
/// Винесено в окремий файл, щоб не захаращувати логіку віджета.
class VideoUploadingStyles {
  VideoUploadingStyles._();

  // ---- Кольори ----
  static const Color primaryColor = Colors.deepPurple;
  static const Color accentColor = Colors.deepPurpleAccent;

  // ---- Відступи контейнера ----
  static const EdgeInsets containerPadding =
  EdgeInsets.symmetric(horizontal: 12, vertical: 4);

  static const EdgeInsets actionsRowPadding =
  EdgeInsets.symmetric(horizontal: 30);

  static const double sectionGapSmall = 7;
  static const double sectionGapMedium = 12;
  static const double sectionGapLarge = 16;
  static const double bottomSpacer = 100;

  // ---- Поле "Name" ----
  static InputDecoration titleFieldDecoration() {
    return InputDecoration(
      labelText: 'Name',
      labelStyle: const TextStyle(color: primaryColor),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.4)),
      ),
    );
  }

  // ---- Текст кнопок ----
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );

  // ---- Кнопка "Cancel" ----
  static ButtonStyle cancelButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: accentColor),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // ---- Кнопка "Submit" ----
  static ButtonStyle submitButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    );
  }
}