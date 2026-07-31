import 'package:eiga/backend/data/dto/PhraseDataDTO.dart';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/data/models/subtitleSettings.dart';
import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/providers/subtitle_settings_provider.dart';
import 'package:eiga/providers/FlickManagerState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FullScreenPhraseTranslatedWidget extends ConsumerStatefulWidget {
  final PhraseObject phraseObject;

  const FullScreenPhraseTranslatedWidget({super.key, required this.phraseObject});

  @override
  ConsumerState<FullScreenPhraseTranslatedWidget> createState() => _FullScreenPhraseTranslatedWidgetState();
}

class _FullScreenPhraseTranslatedWidgetState extends ConsumerState<FullScreenPhraseTranslatedWidget> {
  late Future<PhraseDataDTO> _praseDataDTOFuture;
  int? _selectedBlockId;

  @override
  void initState() {
    super.initState();
    _praseDataDTOFuture = _loadData();
  }

  @override
  void didUpdateWidget(FullScreenPhraseTranslatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phraseObject.id != widget.phraseObject.id) {
      setState(() {
        _praseDataDTOFuture = _loadData();
        _selectedBlockId = null;
      });
    }
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
    setState(() {
      _selectedBlockId = (_selectedBlockId == blockId) ? null : blockId;
      final controlManager = ref.read(flickManagerProvider).flickManager?.flickControlManager;
      if (_selectedBlockId != null) {
        controlManager?.pause();
      } else {
        controlManager?.play();
      }
    });
  }

  String _getVersionText(WordObject word, String key) {
    try {
      var item = word.versions.where((v) => v.key == key).firstOrNull;
      if (item == null && key == 'romaji') {
        item = word.versions.where((v) => v.key == 'romanji').firstOrNull;
      }
      return item?.text ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final readingSettings = ref.watch(readingTypeNotifierProvider).value;
    final mainOption = readingSettings?.mainOption ?? 'original';
    final additionalOption = readingSettings?.additionalOptions ?? '';
    final isLocked = ref.watch(isLockedVideoProvider);
    final subtitleSettings = ref.watch(subtitleSettingsNotifierProvider).value;

    return FutureBuilder<PhraseDataDTO>(
      future: _praseDataDTOFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return _FullScreenPhraseContent(
          blocks: snapshot.data!.blocks,
          allWords: snapshot.data!.allOriginalWords,
          mainOption: mainOption,
          additionalOption: additionalOption,
          selectedBlockId: _selectedBlockId,
          onToggleSelection: _toggleSelection,
          getVersionText: _getVersionText,
          isLocked: isLocked,
          config: subtitleSettings?.fullScreen,
        );
      },
    );
  }
}

class _FullScreenPhraseContent extends StatelessWidget {
  final List<BlockObject> blocks;
  final List<WordObject> allWords;
  final String mainOption;
  final String additionalOption;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;
  final String Function(WordObject, String) getVersionText;
  final bool isLocked;
  final SubtitleConfig? config;

  const _FullScreenPhraseContent({
    required this.blocks,
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
    required this.isLocked,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final blocksList = [...blocks]
      ..sort((a, b) => a.translatedPositionIndex.first.compareTo(b.translatedPositionIndex.first));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: config?.backgroundEnabled == true 
            ? Color(config!.backgroundColor) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _FullScreenWordsSection(
            allWords: allWords,
            mainOption: mainOption,
            additionalOption: additionalOption,
            selectedBlockId: selectedBlockId,
            onToggleSelection: onToggleSelection,
            getVersionText: getVersionText,
            isLocked: isLocked,
            config: config,
          ),
          const SizedBox(height: 8),
          _FullScreenBlocksSection(
            blocksList: blocksList,
            selectedBlockId: selectedBlockId,
            onToggleSelection: onToggleSelection,
            isLocked: isLocked,
            config: config,
          ),
        ],
      ),
    );
  }
}

class _FullScreenWordsSection extends StatelessWidget {
  final List<WordObject> allWords;
  final String mainOption;
  final String additionalOption;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;
  final String Function(WordObject, String) getVersionText;
  final bool isLocked;
  final SubtitleConfig? config;

  const _FullScreenWordsSection({
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
    required this.isLocked,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final languageConfig = ReadingTypeLanguageConfigRegistry.getConfing('japanese');
    final needsSpacing = languageConfig.spacingOptions.contains(mainOption);

    return Wrap(
      spacing: needsSpacing ? 8 : 0,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: allWords.map((word) {
        final mainText = getVersionText(word, mainOption).trim();
        final additionalText = getVersionText(word, additionalOption).trim();

        return _FullScreenWordItem(
          mainWord: mainText,
          additionalWord: additionalText,
          isSelected: selectedBlockId == word.blockId,
          onTap: isLocked ? () => onToggleSelection(word.blockId) : null,
          config: config,
          needsSpacing: needsSpacing,
        );
      }).toList(),
    );
  }
}

class _FullScreenWordItem extends StatelessWidget {
  final String mainWord;
  final String additionalWord;
  final bool isSelected;
  final VoidCallback? onTap;
  final SubtitleConfig? config;
  final bool needsSpacing;

  const _FullScreenWordItem({
    required this.mainWord,
    required this.additionalWord,
    required this.isSelected,
    this.onTap,
    this.config,
    required this.needsSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final origSize = config?.fontSizeOriginal ?? 28.0;
    final addSize = config?.fontSizeAdditional ?? 16.0;
    
    final shadowOffset = origSize * 0.05;
    final shadow = [
      Shadow(offset: Offset(-shadowOffset, -shadowOffset), color: Colors.black),
      Shadow(offset: Offset(shadowOffset, -shadowOffset), color: Colors.black),
      Shadow(offset: Offset(shadowOffset, shadowOffset), color: Colors.black),
      Shadow(offset: Offset(-shadowOffset, shadowOffset), color: Colors.black),
    ];

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: isSelected ? origSize * 0.2 : (needsSpacing ? origSize * 0.2 : 0),
        vertical: origSize * 0.05,
      ),
      decoration: BoxDecoration(
        color: isSelected ? Colors.yellowAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(origSize * 0.25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (additionalWord.isNotEmpty)
            Text(
              additionalWord,
              style: TextStyle(
                fontSize: addSize,
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: config?.isBoldAdditional == true ? FontWeight.bold : FontWeight.w500,
                fontStyle: config?.isItalicAdditional == true ? FontStyle.italic : FontStyle.normal,
                shadows: isSelected ? null : shadow,
                height: 1.1,
              ),
            ),
          Text(
            mainWord,
            style: TextStyle(
              fontSize: origSize,
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: config?.isBoldOriginal == true ? FontWeight.bold : FontWeight.bold,
              fontStyle: config?.isItalicOriginal == true ? FontStyle.italic : FontStyle.normal,
              shadows: isSelected ? null : shadow,
              height: 1.1,
              letterSpacing: needsSpacing ? null : 0,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        onTapDown: (_) {}, // Block player pause
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }
    return content;
  }
}

class _FullScreenBlocksSection extends StatelessWidget {
  final List<BlockObject> blocksList;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;
  final bool isLocked;
  final SubtitleConfig? config;

  const _FullScreenBlocksSection({
    required this.blocksList,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.isLocked,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final transSize = config?.fontSizeTranslation ?? 20.0;
    final shadowOffset = transSize * 0.05;
    
    final shadowBase = [
      Shadow(offset: Offset(-shadowOffset, -shadowOffset), color: Colors.black),
      Shadow(offset: Offset(shadowOffset, -shadowOffset), color: Colors.black),
      Shadow(offset: Offset(shadowOffset, shadowOffset), color: Colors.black),
      Shadow(offset: Offset(-shadowOffset, shadowOffset), color: Colors.black),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: transSize * 0.1,
      runSpacing: transSize * 0.1,
      children: blocksList.map((block) {
        final isSelected = selectedBlockId == block.id;
        final blockText = block.blockTranslation?.trim() ?? '';

        return GestureDetector(
          onTap: isLocked ? () => onToggleSelection(block.id) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: transSize * 0.15, vertical: transSize * 0.05),
            decoration: BoxDecoration(
              color: isSelected ? Colors.yellowAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(transSize * 0.3),
            ),
            child: Text(
              blockText,
              style: TextStyle(
                fontSize: transSize,
                color: isSelected ? Colors.black : Colors.yellowAccent,
                fontStyle: (config?.isItalicTranslation ?? true) ? FontStyle.italic : FontStyle.normal,
                fontWeight: (config?.isBoldTranslation ?? false || isSelected) ? FontWeight.bold : FontWeight.normal,
                shadows: isSelected ? null : shadowBase,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
