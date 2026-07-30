import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:flutter/material.dart';
import '../../styles/phraseListStyles.dart';

class PhraseNotTranslatedWidget extends StatelessWidget {
  final PhraseObject phraseObject;
  final bool isActive;

  const PhraseNotTranslatedWidget({
    super.key,
    required this.phraseObject,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Додаємо вертикальний відступ для вирівнювання з висотою фурігани
      child: Text(
        phraseObject.originalPhrase ?? '',
        style: PhraseListStyles.getPhraseTextStyle(isActive: isActive),
        textAlign: TextAlign.left,
      ),
    );
  }
}