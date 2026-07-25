import 'package:flutter/material.dart';
import 'languagePreviewWidget.dart';

class LanguageButtonWidget extends StatelessWidget {
  final String original;
  final String translation;

  const LanguageButtonWidget({super.key, required this.original, required this.translation});

  void _showAllLanguages(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "ModelsLabel",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 5)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const LanguagePreviewWidget(),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
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
          color: hasLanguages ? Colors.deepPurpleAccent.withOpacity(0.3) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasLanguages ? Colors.deepPurpleAccent.shade100 : Colors.deepPurple.withOpacity(0.25),
            width: hasLanguages ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasOriginal ? original : 'original',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: hasOriginal ? Colors.deepPurpleAccent : Colors.deepPurple.withOpacity(0.4)),
            ),
            const SizedBox(width: 1),
            Icon(Icons.arrow_right_alt, size: 20, color: hasLanguages ? Colors.deepPurpleAccent : Colors.deepPurple.withOpacity(0.4)),
            const SizedBox(width: 1),
            Text(
              hasTranslation ? translation : 'translation',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: hasTranslation ? Colors.deepPurpleAccent : Colors.deepPurple.withOpacity(0.4)),
            ),
          ],
        ),
      ),
    );
  }
}