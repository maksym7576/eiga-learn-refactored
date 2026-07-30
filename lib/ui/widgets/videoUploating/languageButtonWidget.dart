import 'package:flutter/material.dart';
import '../dialogs/AppDialog.dart';
import 'languagePreviewWidget.dart';

class LanguageButtonWidget extends StatelessWidget {
  final String original;
  final String translation;

  const LanguageButtonWidget({super.key, required this.original, required this.translation});

  void _showAllLanguages(BuildContext context) {
    AppDialog.show(
      context: context,
      barrierLabel: "ModelsLabel",
      child: const LanguagePreviewWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLanguages = original.isNotEmpty && translation.isNotEmpty;
    final hasOriginal = original.isNotEmpty;
    final hasTranslation = translation.isNotEmpty;

    return GestureDetector(
      onTap: () => _showAllLanguages(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: hasLanguages ? Colors.deepPurpleAccent.withValues(alpha: 0.3) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasLanguages ? Colors.deepPurpleAccent.shade100 : Colors.deepPurple.withValues(alpha: 0.25),
            width: hasLanguages ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasOriginal ? original : 'original',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: hasOriginal ? Colors.deepPurpleAccent : Colors.deepPurple.withValues(alpha: 0.4)),
            ),
            const SizedBox(width: 1),
            Icon(Icons.arrow_right_alt, size: 20, color: hasLanguages ? Colors.deepPurpleAccent : Colors.deepPurple.withValues(alpha: 0.4)),
            const SizedBox(width: 1),
            Text(
              hasTranslation ? translation : 'translation',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: hasTranslation ? Colors.deepPurpleAccent : Colors.deepPurple.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }
}