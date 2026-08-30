import 'dart:io';

import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../backend/data/dto/AniListDataDTO.dart';
import '../../../../providers/DTOProviders.dart';
import '../../../../providers/searchProvider.dart';
import '../../../../providers/videoComponentsProvider.dart';
import '../../searchWidgets/AniListSearch/AniListSearchSource.dart';
import 'VideoTitleField.dart';

class AttachSubtitleBottomSheet extends ConsumerStatefulWidget {
  final TextEditingController titleController;

  const AttachSubtitleBottomSheet({
    super.key,
    required this.titleController,
  });

  @override
  ConsumerState<AttachSubtitleBottomSheet> createState() => _AttachSubtitleBottomSheetState();
}

class _AttachSubtitleBottomSheetState extends ConsumerState<AttachSubtitleBottomSheet> {
  final _source = AniListSearchSource();
  bool _showResults = false;

  Future<void> _handleSearch() async {
    final name = widget.titleController.text.trim();
    if (name.isEmpty) return;

    final key = _source.key;
    ref.read(isSearchingProvider(key).notifier).state = true;
    setState(() => _showResults = true);

    try {
      final results = await _source.search(name, {}, ref);
      ref.read(searchResultsProvider(key).notifier).state = results;
    } finally {
      ref.read(isSearchingProvider(key).notifier).state = false;
    }
  }

  void _selectAnime(AniListDataDTO anime) {
    final key = _source.key;
    ref.read(selectedEntryProvider(key).notifier).state = anime;
    setState(() => _showResults = false);
    widget.titleController.text = _source.entryLabel(anime);
    
    // Also trigger resolve to update global provider
    _source.resolve(anime, ref);
  }

  Future<void> _pickSrt() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['srt'],
    );
    if (result != null) {
      ref.read(srtPathProvider.notifier).state = result.files.first.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = _source.key;
    final searchResults = ref.watchAniListResults();
    final isSearching = ref.watch(isSearchingProvider(key));
    final selectedAnime = ref.watchAniListSelectedEntry();
    final srtPath = ref.watch(srtPathProvider);
    final theme = AdditionalWindowTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attach subtitles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.titleColor,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, size: 22, color: theme.subtitleColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Name',
            style: TextStyle(fontSize: 13, color: theme.subtitleColor),
          ),
          const SizedBox(height: 6),
          VideoTitleField(
            controller: widget.titleController,
            onSearch: _handleSearch,
            isLoading: isSearching,
            showToggle: searchResults.isNotEmpty || selectedAnime != null,
            isResultsVisible: _showResults,
            onToggleResults: () => setState(() => _showResults = !_showResults),
          ),
          const SizedBox(height: 16),
          if (_showResults)
            Flexible(
              child: isSearching
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF2196F3))),
                    )
                  : searchResults.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: Text('No results found', style: TextStyle(color: theme.subtitleColor))),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.48,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final anime = searchResults[index];
                            final isSelected = selectedAnime?.id == anime.id;
                            return _source.buildEntryCard(
                              anime,
                              isSelected,
                              () => _selectAnime(anime),
                            );
                          },
                        ),
            ),
          if (!_showResults && selectedAnime != null)
            _buildSelectedAnimeInfo(selectedAnime, theme),
          const SizedBox(height: 12),
          _buildSubtitlePicker(srtPath, theme),
          const SizedBox(height: 20),
          _buildActionButtons(theme),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSelectedAnimeInfo(AniListDataDTO anime, AdditionalWindowTheme theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.selectionBoxBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.selectionAccentColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          if (anime.coverImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                anime.coverImageUrl!,
                width: 40,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 40,
                  height: 56,
                  color: theme.cardBackground,
                  child: Icon(Icons.image_not_supported, size: 16, color: theme.mutedText),
                ),
              ),
            ),
          if (anime.coverImageUrl != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 14, color: theme.selectionAccentColor),
                    const SizedBox(width: 6),
                    Text(
                      'Selected entry',
                      style: TextStyle(fontSize: 11, color: theme.subtitleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  anime.romajiTitle ?? anime.englishTitle ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.normalText,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            icon: Icon(Icons.close, size: 18, color: theme.mutedText),
            onPressed: () {
              ref.read(selectedEntryProvider(_source.key).notifier).state = null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitlePicker(String? srtPath, AdditionalWindowTheme theme) {
    return InkWell(
      onTap: _pickSrt,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.inputBorderColor, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.selectionAccentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.description, color: theme.selectionAccentColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    srtPath != null ? srtPath.split(Platform.pathSeparator).last : 'No subtitles attached',
                    style: TextStyle(
                      color: theme.normalText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    srtPath != null ? 'Subtitle file attached' : 'Pick a file',
                    style: TextStyle(fontSize: 12, color: theme.mutedText),
                  ),
                ],
              ),
            ),
            if (srtPath != null)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.close, size: 16, color: theme.mutedText),
                onPressed: () => ref.read(srtPathProvider.notifier).state = null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AdditionalWindowTheme theme) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: theme.cancelButtonText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: () async {
                final selectedAnime = ref.read(selectedEntryProvider(_source.key)) as AniListDataDTO?;
                if (selectedAnime != null && selectedAnime.id != null) {
                  await ref.read(aniListProvider.notifier).refresh(selectedAnime.id!);
                }
                if (!mounted) return;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.addButtonBackground,
                foregroundColor: theme.addButtonText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_circle_outline, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Add subtitles',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
