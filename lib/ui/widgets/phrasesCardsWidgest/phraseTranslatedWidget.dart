import 'package:eiga/backend/data/dto/PhraseDataDTO.dart';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/data/models/subtitleSettings.dart';
import 'package:eiga/backend/services/petition_ai/parsers/utils/romaji_utils.dart';
import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/subtitle_settings_provider.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/providers/FlickManagerState.dart';
import 'package:eiga/ui/styles/PhraseListTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final subtitleSettings = ref.watch(subtitleSettingsNotifierProvider).value;
    final video = ref.watch(currentVideoProvider).value;

    return FutureBuilder<PhraseDataDTO>(
      future: _praseDataDTOFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
          config: subtitleSettings?.portrait,
          originalLanguage: video?.originalLanguage,
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
  final SubtitleConfig? config;
  final String? originalLanguage;

  const _PhraseTranslatedContent({
    required this.blocks,
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
    this.config,
    this.originalLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = PhraseListTheme.of(context);
    final blocksList = [...blocks]
      ..sort((a, b) => a.translatedPositionIndex.first.compareTo(b.translatedPositionIndex.first));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _WordsSection(
          allWords: allWords,
          mainOption: mainOption,
          additionalOption: additionalOption,
          selectedBlockId: selectedBlockId,
          onToggleSelection: onToggleSelection,
          getVersionText: getVersionText,
          config: config,
          originalLanguage: originalLanguage,
          theme: theme,
        ),
        const SizedBox(height: 4),
        _BlocksSection(
          blocksList: blocksList,
          selectedBlockId: selectedBlockId,
          onToggleSelection: onToggleSelection,
          config: config,
          theme: theme,
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
  final SubtitleConfig? config;
  final String? originalLanguage;
  final PhraseListTheme theme;

  const _WordsSection({
    required this.allWords,
    required this.mainOption,
    required this.additionalOption,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.getVersionText,
    required this.theme,
    this.config,
    this.originalLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final languageConfig = ReadingTypeLanguageConfigRegistry.getConfing(originalLanguage ?? 'japanese');
    final needsSpacing = languageConfig.spacingOptions.contains(mainOption);

    bool isQuoteOpen = false;
    String lastWord = '';

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: allWords.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;

        final mainText = getVersionText(word, mainOption).trim();
        final additionalText = getVersionText(word, additionalOption).trim();

        bool hasLeadingSpace = false;

        if (needsSpacing && index > 0 && mainText.isNotEmpty) {
          final isOpening = RomajiUtils.isOpeningPunctuation(mainText);
          final isClosing = RomajiUtils.isClosingPunctuation(mainText);
          final isNeutral = RomajiUtils.isNeutralPunctuation(mainText);

          final lastWasOpening = RomajiUtils.isOpeningPunctuation(lastWord);

          if (isNeutral) {
            if (!isQuoteOpen) {
              hasLeadingSpace = !lastWasOpening;
            }
            isQuoteOpen = !isQuoteOpen;
          } else if (isOpening) {
            hasLeadingSpace = !lastWasOpening;
          } else if (isClosing) {
            hasLeadingSpace = false;
          } else {
            hasLeadingSpace = !lastWasOpening && !(RomajiUtils.isNeutralPunctuation(lastWord) && isQuoteOpen);
          }
        }

        if (mainText.isNotEmpty) {
          lastWord = mainText;
        }

        final bool isOnlyPunc = RomajiUtils.isOnlyPunctuation(mainText);
        final bool sticksToPrevious = index > 0 && 
            allWords[index - 1].blockId == word.blockId && 
            !hasLeadingSpace;
        
        bool sticksToNext = false;
        if (index < allWords.length - 1) {
          final nextWord = allWords[index + 1];
          final nextMainText = getVersionText(nextWord, mainOption).trim();
          if (nextWord.blockId == word.blockId && nextMainText.isNotEmpty) {
             final nextIsOpening = RomajiUtils.isOpeningPunctuation(nextMainText);
             final nextIsClosing = RomajiUtils.isClosingPunctuation(nextMainText);
             
             bool nextHasLeadingSpace = false;
             if (needsSpacing) {
                if (nextIsOpening) {
                   nextHasLeadingSpace = !RomajiUtils.isOpeningPunctuation(mainText);
                } else if (nextIsClosing) {
                   nextHasLeadingSpace = false;
                } else {
                   nextHasLeadingSpace = !RomajiUtils.isOpeningPunctuation(mainText) && 
                      !(RomajiUtils.isNeutralPunctuation(mainText) && isQuoteOpen);
                }
             }
             sticksToNext = !nextHasLeadingSpace;
          }
        }

        return _WordItem(
          isSelected: selectedBlockId == word.blockId,
          cleanedMainWord: mainText,
          cleanedAdditionalWord: isOnlyPunc ? '' : additionalText,
          onTap: () => onToggleSelection(word.blockId),
          config: config,
          needsSpacing: needsSpacing,
          hasLeadingSpace: hasLeadingSpace,
          sticksToPrevious: sticksToPrevious,
          sticksToNext: sticksToNext,
          theme: theme,
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
  final SubtitleConfig? config;
  final bool needsSpacing;
  final bool hasLeadingSpace;
  final bool sticksToPrevious;
  final bool sticksToNext;
  final PhraseListTheme theme;

  const _WordItem({
    required this.isSelected,
    required this.cleanedMainWord,
    required this.cleanedAdditionalWord,
    required this.onTap,
    required this.theme,
    this.config,
    required this.needsSpacing,
    required this.hasLeadingSpace,
    this.sticksToPrevious = false,
    this.sticksToNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final origSize = config?.fontSizeOriginal ?? 17;
    final addSize = config?.fontSizeAdditional ?? 10;
    
    final double leadingSpaceWidth = hasLeadingSpace ? origSize * 0.25 : 0;

    final additionalStyle = TextStyle(
      color: isSelected ? theme.primaryAccent : theme.mutedText,
      fontSize: addSize,
      fontWeight: config?.isBoldAdditional == true ? FontWeight.bold : null,
      fontStyle: config?.isItalicAdditional == true ? FontStyle.italic : null,
      height: 1.1,
    );
    final mainStyle = TextStyle(
      color: isSelected ? theme.primaryAccent : theme.normalText,
      fontSize: origSize,
      fontWeight: (config?.isBoldOriginal == true || isSelected) ? FontWeight.bold : FontWeight.w500,
      fontStyle: config?.isItalicOriginal == true ? FontStyle.italic : null,
      decoration: isSelected ? TextDecoration.underline : null,
      decorationColor: theme.successAccent,
      height: 1.1,
      letterSpacing: needsSpacing ? null : 0,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(
          left: leadingSpaceWidth + (isSelected && !sticksToPrevious ? origSize * 0.1 : 0),
          right: isSelected && !sticksToNext ? origSize * 0.1 : 0,
        ),
        child: Container(
          decoration: isSelected 
            ? BoxDecoration(
                color: theme.primaryAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(sticksToPrevious ? 0 : 4),
                  right: Radius.circular(sticksToNext ? 0 : 4),
                ),
              )
            : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                cleanedAdditionalWord,
                style: additionalStyle,
              ),
              Text(
                cleanedMainWord,
                style: mainStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlocksSection extends StatelessWidget {
  final List<BlockObject> blocksList;
  final int? selectedBlockId;
  final Function(int?) onToggleSelection;
  final SubtitleConfig? config;
  final PhraseListTheme theme;

  const _BlocksSection({
    required this.blocksList,
    required this.selectedBlockId,
    required this.onToggleSelection,
    required this.theme,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final transSize = config?.fontSizeTranslation ?? 14;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text.rich(
        TextSpan(
          children: blocksList.map((block) {
            final blockText = block.blockTranslation?.trim() ?? '';
            final isSelected = selectedBlockId == block.id;
            return TextSpan(
              text: '$blockText\u2009',
              style: TextStyle(
                color: isSelected ? theme.primaryAccent : theme.normalText.withValues(alpha: 0.8),
                fontSize: transSize,
                fontWeight: config?.isBoldTranslation == true ? FontWeight.bold : (isSelected ? FontWeight.bold : null),
                fontStyle: (config?.isItalicTranslation == true || !isSelected) ? FontStyle.italic : null,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => onToggleSelection(block.id),
            );
          }).toList(),
        ),
        softWrap: true,
        overflow: TextOverflow.visible,
        textAlign: TextAlign.center,
      ),
    );
  }
}
