import 'package:eiga/backend/data/dto/PhraseDataDTO.dart';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../styles/phraseListStyles.dart';

class PhraseTranslatedWidget extends ConsumerStatefulWidget {
  final PhraseObject phraseObject;

  const PhraseTranslatedWidget({super.key, required this.phraseObject});

  @override
  ConsumerState<PhraseTranslatedWidget> createState() => _PhraseTranslatedWidgetState();
}

class _PhraseTranslatedWidgetState extends ConsumerState<PhraseTranslatedWidget> {
  late Future<PhraseDataDTO> _praseDataDTOFuture;
  int? _selectedBlockId;

  @override
  void initState() {
    super.initState();
    _praseDataDTOFuture = _loadData();
  }

  Future<PhraseDataDTO> _loadData() async {
    final blockService = ref.read(blockServiceProvider);
    final wordService = ref.read(wordServiceProvider);

    final blocks = await blockService.getBlocksForPhrase(widget.phraseObject.id);
    blocks.sort((a, b) => a.translatedPositionIndex.first.compareTo(b.translatedPositionIndex.first));

    List<WordObject> allWords = [];
    for (var block in blocks) {
      allWords.addAll(await wordService.getWordsBlocks([block.id]));
    }
    allWords.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));

    return PhraseDataDTO(blocks, allWords);
  }

  void _toggleSelection(int? blockId) {
    if (blockId == null) return;
    setState(() => _selectedBlockId = (_selectedBlockId == blockId) ? null : blockId);
  }

  String _getVersionText(WordObject word, String key) {
    try {
      return word.versions.firstWhere((v) => v.key == key).text ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final readingSettings = ref.watch(readingTypeNotifierProvider).value;
    final mainOption = readingSettings?.mainOption ?? 'original';
    final additionalOption = readingSettings?.additionalOptions ?? '';

    return FutureBuilder<PhraseDataDTO>(
      future: _praseDataDTOFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Компактний індикатор завантаження без величезних відступів
          return const SizedBox(
            height: 40,
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text(
            'Error to load data',
            textAlign: TextAlign.left,
          );
        }

        return _PhraseTranslatedContent(
          blocks: snapshot.data!.blocks,
          allWords: snapshot.data!.allOriginalWords,
          mainOption: mainOption,
          additionalOption: additionalOption,
          selectedBlockId: _selectedBlockId,
          onToggleSelection: _toggleSelection,
          getVersionText: _getVersionText,
        );
      },
    );
  }
}

class _PhraseTranslatedContent extends StatelessWidget {
  final List<BlockObject> blocks;
  final List<WordObject> allWords;
  final String mainOption;
  final String additionalOption;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;
  final String Function(WordObject, String) getVersionText;

  const _PhraseTranslatedContent({
    required this.blocks,
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
  });

  @override
  Widget build(BuildContext context) {
    final blocksList = [...blocks]
      ..sort((a, b) => a.translatedPositionIndex.first.compareTo(b.translatedPositionIndex.first));

    // Прибрано зайвий Padding, який збільшував розмір картки
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Чітке вирівнювання по лівому краю
      mainAxisSize: MainAxisSize.min,
      children: [
        _WordsSection(
          allWords: allWords,
          mainOption: mainOption,
          additionalOption: additionalOption,
          selectedBlockId: selectedBlockId,
          onToggleSelection: onToggleSelection,
          getVersionText: getVersionText,
        ),
        const SizedBox(height: PhraseListStyles.blockSectionSpacing),
        _BlocksSection(
          blocksList: blocksList,
          selectedBlockId: selectedBlockId,
          onToggleSelection: onToggleSelection,
        ),
      ],
    );
  }
}

class _WordsSection extends StatelessWidget {
  final List<WordObject> allWords;
  final String mainOption;
  final String additionalOption;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;
  final String Function(WordObject, String) getVersionText;

  const _WordsSection({
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: PhraseListStyles.wordSpacing,
      runSpacing: PhraseListStyles.wordRunSpacing,
      children: allWords.map((word) {
        return _WordItem(
          isSelected: selectedBlockId == word.blockId,
          cleanedMainWord: getVersionText(word, mainOption).trim(),
          cleanedAdditionalWord: getVersionText(word, additionalOption).trim(),
          onTap: () => onToggleSelection(word.blockId),
        );
      }).toList(),
    );
  }
}

class _WordItem extends StatelessWidget {
  final bool isSelected;
  final String cleanedMainWord;
  final String cleanedAdditionalWord;
  final VoidCallback onTap;

  const _WordItem({
    required this.isSelected,
    required this.cleanedMainWord,
    required this.cleanedAdditionalWord,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: PhraseListStyles.durationWordAnimation,
        curve: PhraseListStyles.curveWord,
        padding: const EdgeInsets.all(PhraseListStyles.wordPadding),
        child: Column(
          children: [
            Text(
              cleanedAdditionalWord,
              style: PhraseListStyles.getWordTextStyle(isSelected: isSelected, isAdditional: true),
            ),
            Text(
              cleanedMainWord,
              style: PhraseListStyles.getWordTextStyle(isSelected: isSelected, isAdditional: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlocksSection extends StatelessWidget {
  final List<BlockObject> blocksList;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;

  const _BlocksSection({
    required this.blocksList,
    required this.selectedBlockId,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: blocksList.map((block) {
          return TextSpan(
            text: '${block.blockTranslation?.trim() ?? ''} ',
            style: PhraseListStyles.getBlockTextStyle(isSelected: selectedBlockId == block.id),
            recognizer: TapGestureRecognizer()..onTap = () => onToggleSelection(block.id),
          );
        }).toList(),
      ),
    );
  }
}