

import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhraseTranslatedWidget extends ConsumerStatefulWidget {
  final PhraseObject phraseObject;
  const PhraseTranslatedWidget({super.key, required this.phraseObject});

  @override
  ConsumerState<PhraseTranslatedWidget> createState() => _PhraseTranslatedWidgetState();
}

class _PhraseTranslatedWidgetState extends ConsumerState<PhraseTranslatedWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}