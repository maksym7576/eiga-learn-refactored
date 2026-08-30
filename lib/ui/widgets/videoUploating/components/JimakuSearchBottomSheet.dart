import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';
import 'package:eiga/backend/data/dto/JimakuFileOrGroupDTO.dart';
import 'package:eiga/providers/searchProvider.dart';
import 'package:eiga/ui/widgets/searchWidgets/JimakuSearch/JimakuSubtitleSource.dart';
import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:eiga/ui/widgets/videoUploating/components/VideoTitleField.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/DTOProviders.dart';

class JimakuSearchBottomSheet extends ConsumerStatefulWidget {
  final void Function(String result) onResolved;

  const JimakuSearchBottomSheet({
    super.key,
    required this.onResolved,
  });

  @override
  ConsumerState<JimakuSearchBottomSheet> createState() => _JimakuSearchBottomSheetState();
}

class _JimakuSearchBottomSheetState extends ConsumerState<JimakuSearchBottomSheet> {
  final _source = JimakuSubtitleSource();
  final _controller = TextEditingController();
  final _fileFilterController = TextEditingController();
  final _scrollController = ScrollController();
  
  late final String _key = _source.key;
  bool _showResults = false;
  bool _isFetching = false;
  int _lastMetadataIndex = 0;
  static const int _chunkSize = 12; // Slightly more than one screen

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fileFilterController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = ref.read(searchFiltersProvider(_key));
      if (current.isEmpty) {
        ref.read(searchFiltersProvider(_key).notifier).state =
            Map.of(_source.defaultFilters);
      }
    });
  }

  @override
  void dispose() {
    _fileFilterController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_showResults || _isFetching) return;
    
    // Trigger when 70% scrolled
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent * 0.7) {
      final results = ref.read(searchResultsProvider(_key)).cast<JimakuDataDTO>();
      if (_lastMetadataIndex < results.length) {
        _loadNextMetadataChunk(results);
      }
    }
  }

  Future<void> _loadNextMetadataChunk(List<JimakuDataDTO> results) async {
    if (_isFetching || _lastMetadataIndex >= results.length) return;
    
    setState(() => _isFetching = true);
    
    final start = _lastMetadataIndex;
    final end = (start + _chunkSize).clamp(0, results.length);
    
    try {
      await _source.fetchMetadataForRange(results, start, end, ref);
      _lastMetadataIndex = end;
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  Future<void> _handleSearch() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    ref.read(selectedEntryProvider(_key).notifier).state = null;
    ref.read(filesProvider(_key).notifier).state = [];
    ref.read(selectedResultProvider(_key).notifier).state = null;
    ref.read(searchMetadataProvider(_key).notifier).state = {};
    ref.read(isSearchingProvider(_key).notifier).state = true;
    
    _lastMetadataIndex = 0;
    _isFetching = false;
    
    setState(() => _showResults = true);

    try {
      final filters = ref.read(searchFiltersProvider(_key));
      final results = await _source.search(query, filters, ref);
      ref.read(searchResultsProvider(_key).notifier).state = results;
      
      if (results.isNotEmpty) {
        // Use post frame to ensure list is rendered before we might trigger more
        WidgetsBinding.instance.addPostFrameCallback((_) {
           _loadNextMetadataChunk(results);
        });
      }
    } finally {
      ref.read(isSearchingProvider(_key).notifier).state = false;
    }
  }

  Future<void> _onEntryTap(JimakuDataDTO entry) async {
    ref.read(selectedEntryProvider(_key).notifier).state = entry;
    ref.read(selectedResultProvider(_key).notifier).state = null;
    ref.read(filesProvider(_key).notifier).state = [];
    ref.read(isLoadingFilesProvider(_key).notifier).state = true;

    try {
      final filters = ref.read(searchFiltersProvider(_key));
      final files = await _source.getFiles(entry, filters, ref);
      ref.read(filesProvider(_key).notifier).state = files;
    } finally {
      ref.read(isLoadingFilesProvider(_key).notifier).state = false;
    }
  }

  void _goBack() {
    ref.read(selectedEntryProvider(_key).notifier).state = null;
    ref.read(filesProvider(_key).notifier).state = [];
    ref.read(selectedResultProvider(_key).notifier).state = null;
  }

  Future<void> _confirm() async {
    final selected = ref.read(selectedResultProvider(_key));
    if (selected == null) return;

    ref.read(isResolvingProvider(_key).notifier).state = true;
    try {
      final result = await _source.resolve(selected, ref);
      widget.onResolved(result);
      if (mounted) Navigator.pop(context);
    } finally {
      ref.read(isResolvingProvider(_key).notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final results = ref.watch(searchResultsProvider(_key)).cast<JimakuDataDTO>();
    final selectedEntry = ref.watch(selectedEntryProvider(_key)) as JimakuDataDTO?;
    final files = ref.watch(filesProvider(_key)).cast<JimakuFileOrGroupDTO>();
    final selectedResult = ref.watch(selectedResultProvider(_key));
    final isSearching = ref.watch(isSearchingProvider(_key));
    final isLoadingFiles = ref.watch(isLoadingFilesProvider(_key));
    final isResolving = ref.watch(isResolvingProvider(_key));

    final showDetails = selectedEntry != null;

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
          _buildHeader(theme, showDetails, selectedEntry),
          if (showDetails && selectedEntry != null)
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 0, bottom: 12),
              child: Text(
                selectedEntry.displayTitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: theme.selectionAccentColor,
                ),
              ),
            )
          else
            const SizedBox(height: 16),
          if (!showDetails) ...[
            Text('Anime Name', style: TextStyle(fontSize: 13, color: theme.subtitleColor)),
            const SizedBox(height: 6),
            VideoTitleField(
              controller: _controller,
              onSearch: _handleSearch,
              isLoading: isSearching,
            ),
            const SizedBox(height: 8),
            _source.buildFilterBar(context, ref),
          ],
          const SizedBox(height: 12),
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: showDetails
                  ? _buildDetailsView(theme, selectedEntry, isLoadingFiles, files, selectedResult)
                  : _buildSearchView(theme, isSearching, results),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButtons(theme, showDetails, selectedResult, isResolving),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader(AdditionalWindowTheme theme, bool showDetails, JimakuDataDTO? selectedEntry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              if (showDetails)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.arrow_back_rounded, size: 20, color: theme.subtitleColor),
                  onPressed: _goBack,
                ),
              if (showDetails) const SizedBox(width: 10),
              Expanded(
                child: Text(
                  showDetails ? 'Select subtitle' : 'Jimaku Subtitles',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: theme.titleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_rounded, size: 20, color: theme.subtitleColor),
        ),
      ],
    );
  }

  Widget _buildSearchView(AdditionalWindowTheme theme, bool isSearching, List<JimakuDataDTO> results) {
    if (isSearching) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_showResults) return const SizedBox.shrink();
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text('No results found', style: TextStyle(color: theme.subtitleColor))),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.48,
        crossAxisSpacing: 14,
        mainAxisSpacing: 16,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) => _source.buildEntryCard(results[index], false, () => _onEntryTap(results[index])),
    );
  }

  Widget _buildDetailsView(
    AdditionalWindowTheme theme,
    JimakuDataDTO entry,
    bool isLoadingFiles,
    List<JimakuFileOrGroupDTO> files,
    dynamic selectedResult,
  ) {
    if (isLoadingFiles) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final query = _fileFilterController.text.trim().toLowerCase();
    
    // Filter logic: if searching, we flatten and show matching files.
    // If not searching, we show the original list (groups + files).
    final List<JimakuFileOrGroupDTO> filteredFiles;
    if (query.isEmpty) {
      filteredFiles = files;
    } else {
      // Flatten all groups to search through all files
      final List<FileJimakuDTO> allFiles = [];
      for (var item in files) {
        if (item.isGroup) {
          allFiles.addAll(item.group!.files);
        } else {
          allFiles.add(item.file!);
        }
      }
      filteredFiles = allFiles
          .where((f) => f.name.toLowerCase().contains(query))
          .map((f) => JimakuFileOrGroupDTO(file: f))
          .toList();
    }

    if (filteredFiles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text('No files found', style: TextStyle(color: theme.subtitleColor))),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: _fileFilterController,
            style: TextStyle(color: theme.normalText, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search files by name...',
              isDense: true,
              filled: true,
              fillColor: theme.cardBackground,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              prefixIcon: Icon(Icons.search_rounded, size: 18, color: theme.mutedText),
              suffixIcon: query.isNotEmpty 
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 16, color: theme.mutedText),
                      onPressed: () => _fileFilterController.clear(),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.selectionAccentColor.withValues(alpha: 0.3), width: 1),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(Icons.folder_outlined, size: 14, color: theme.mutedText),
              const SizedBox(width: 6),
              Text(
                '/ ${entry.displayTitle}',
                style: TextStyle(fontSize: 12, color: theme.mutedText, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            physics: const ClampingScrollPhysics(),
            itemCount: filteredFiles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final file = filteredFiles[index];
              final isActive = selectedResult != null && _source.fileId(file) == _source.fileId(selectedResult);
              return _source.buildFileCard(file, isActive, () {
                if (!file.isGroup) {
                  ref.read(selectedResultProvider(_key).notifier).state = file;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(AdditionalWindowTheme theme, bool showDetails, dynamic selectedResult, bool isResolving) {
    final isDisabled = (selectedResult == null || isResolving || !showDetails);
    
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: theme.subtitleColor, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: isDisabled ? null : _confirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDisabled ? theme.cardBackground : theme.addButtonBackground,
                foregroundColor: isDisabled ? theme.mutedText : theme.addButtonText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: isResolving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download_rounded, size: 18, color: isDisabled ? theme.mutedText : theme.addButtonText),
                        const SizedBox(width: 6),
                        const Text('Download', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
