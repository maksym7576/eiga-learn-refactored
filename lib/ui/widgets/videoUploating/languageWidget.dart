


import 'package:eiga/providers/dataProviders.dart';
import 'package:eiga/ui/widgets/videoUploating/languagesWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageWidget extends ConsumerWidget {
  final String language;
  final LanguageType type;

  const LanguageWidget({
    Key? key,
    required this.language,
    required this.type,
}) : super(key: key);

  Future<void> setLanguage(WidgetRef ref, String language) async {
    if (type == LanguageType.original) {
      ref.read(languageProvider.notifier).setOriginal(language);
    }
    if (type == LanguageType.translation) {
      ref.read(languageProvider.notifier).setTarget(language);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateLan = ref.watch(languageProvider);
    final original = stateLan.original;
    final translation = stateLan.target;

     Color getColor() {
      if (language == original && type == LanguageType.original || language == translation && type == LanguageType.translation) {
        return Colors.deepPurpleAccent;
      } else if (language == original || language == translation) {
        return Colors.deepPurpleAccent.withOpacity(0.5);
      } else {
        return Colors.white;
      }
    }

    return GestureDetector(
      onTap: () async {
        setLanguage(ref, language);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: getColor(),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
      ),
        child: Center(
          child: Text(
            '$language',
          ),
        ),
    ),
    );
  }
}