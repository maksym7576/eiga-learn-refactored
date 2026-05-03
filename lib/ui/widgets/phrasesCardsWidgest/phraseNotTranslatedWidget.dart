import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhraseNotTranslatedWidget extends ConsumerWidget {
  final PhraseObject phraseObject;
  final bool isActive;

  PhraseNotTranslatedWidget({
    super.key,
    required this.phraseObject,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  phraseObject.originalPhrase!,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
