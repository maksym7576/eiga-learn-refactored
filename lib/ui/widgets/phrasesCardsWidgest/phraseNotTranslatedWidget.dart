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
    // Максимально просто: лише текст. Вирівнювання забезпечує _PhraseCardItem
    return Text(
      phraseObject.originalPhrase ?? '',
      style: PhraseListStyles.getPhraseTextStyle(isActive: isActive),
      textAlign: TextAlign.left,
    );
  }
}