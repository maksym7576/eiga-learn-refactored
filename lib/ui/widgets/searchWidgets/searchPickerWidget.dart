import 'dart:async';
import 'dart:ui';
import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:eiga/ui/widgets/searchWidgets/searchSourceAbstract.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/searchProvider.dart';

class SearchPickerWidget<TEntry, TFile> extends ConsumerStatefulWidget {
  final SearchSource<TEntry, TFile> source;
  final void Function(String result) onResolved;

  const SearchPickerWidget({
    super.key,
    required this.source,
    required this.onResolved,
  });

  @override
  ConsumerState<SearchPickerWidget<TEntry, TFile>> createState() =>
      _SearchPickerWidgetState<TEntry, TFile>();
}

class _SearchPickerWidgetState<TEntry, TFile>
    extends ConsumerState<SearchPickerWidget<TEntry, TFile>> {
  final _controller = TextEditingController();
  late final String _key = widget.source.key;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = ref.read(searchFiltersProvider(_key));
      if (current.isEmpty) {
        ref.read(searchFiltersProvider(_key).notifier).state =
            Map.of(widget.source.defaultFilters);
      }
    });

    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      final query = _controller.text.trim();
      if (query.length >= 3) {
        _search();
      }
    });
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    ref.read(selectedEntryProvider(_key).notifier).state = null;
    ref.read(filesProvider(_key).notifier).state = [];
    ref.read(selectedResultProvider(_key).notifier).state = null;
    ref.read(isSearchingProvider(_key).notifier).state = true;

    try {
      final filters = ref.read(searchFiltersProvider(_key));
      final results = await widget.source.search(query, filters, ref);
      ref.read(searchResultsProvider(_key).notifier).state = results;
    } catch (e) {
      ref.read(searchResultsProvider(_key).notifier).state = [];
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Search error: $e')));
      }
    } finally {
      ref.read(isSearchingProvider(_key).notifier).state = false;
    }
  }

  Future<void> _onEntryTap(TEntry entry) async {
    if (!widget.source.hasFileStage) {
      ref.read(selectedEntryProvider(_key).notifier).state = entry;
      ref.read(selectedResultProvider(_key).notifier).state = entry;
      return;
    }

    ref.read(selectedEntryProvider(_key).notifier).state = entry;
    ref.read(selectedResultProvider(_key).notifier).state = null;
    ref.read(filesProvider(_key).notifier).state = [];
    ref.read(isLoadingFilesProvider(_key).notifier).state = true;

    try {
      final filters = ref.read(searchFiltersProvider(_key));
      final files = await widget.source.getFiles(entry, filters, ref);
      ref.read(filesProvider(_key).notifier).state = files;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading details: $e')));
      }
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
      final result = await widget.source.resolve(selected, ref);
      widget.onResolved(result);

      if (mounted) Navigator.pop(context);

      ref.invalidate(selectedEntryProvider(_key));
      ref.invalidate(filesProvider(_key));
      ref.invalidate(selectedResultProvider(_key));

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      ref.read(isResolvingProvider(_key).notifier).state = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildHeader(bool showDetails, TEntry? selectedEntry, AdditionalWindowTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              if (showDetails)
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.selectionAccentColor),
                  onPressed: _goBack,
                )
              else
                const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showDetails)
                      Text(
                        widget.source.title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.mutedText,
                        ),
                      ),
                    Text(
                      showDetails
                          ? widget.source.entryLabel(selectedEntry as TEntry)
                          : widget.source.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: theme.titleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.close, size: 24, color: theme.normalText),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchView(bool isSearching, List<TEntry> results, AdditionalWindowTheme theme) {
    return Column(
      key: const ValueKey('search-view'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _search(),
                  style: TextStyle(color: theme.normalText),
                  decoration: InputDecoration(
                    hintText: widget.source.searchHint,
                    hintStyle: TextStyle(color: theme.mutedText),
                    filled: true,
                    fillColor: theme.cardBackground,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: isSearching ? null : _search,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.addButtonBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: isSearching
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: theme.addButtonText),
                  )
                      : Icon(Icons.search,
                      color: theme.addButtonText, size: 20),
                ),
              ),
            ],
          ),
        ),
        widget.source.buildFilterBar(context, ref),
        Expanded(
          child: results.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No results',
                style: TextStyle(color: theme.mutedText)),
          )
              : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final entry = results[index];
              return widget.source.buildEntryCard(
                entry,
                false,
                () => _onEntryTap(entry),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsView(
      TEntry entry,
      bool isLoadingFiles,
      List<TFile> files,
      dynamic selectedResult,
      AdditionalWindowTheme theme,
      ) {
    return Column(
      key: const ValueKey('details-view'),
      children: [
        widget.source.buildEntryCard(entry, true, _goBack),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Divider(height: 1, color: theme.dividerColor),
        ),
        Expanded(
          child: isLoadingFiles
              ? const Center(child: CircularProgressIndicator())
              : files.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Nothing found',
                style: TextStyle(color: theme.mutedText)),
          )
              : ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return widget.source.buildFileCard(
                file,
                selectedResult != null &&
                    widget.source.fileId(file) ==
                        widget.source.fileId(selectedResult as TFile),
                    () => ref
                    .read(selectedResultProvider(_key).notifier)
                    .state = file,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider(_key)).cast<TEntry>();
    final selectedEntry = ref.watch(selectedEntryProvider(_key)) as TEntry?;
    final files = ref.watch(filesProvider(_key)).cast<TFile>();
    final selectedResult = ref.watch(selectedResultProvider(_key));
    final isSearching = ref.watch(isSearchingProvider(_key));
    final isLoadingFiles = ref.watch(isLoadingFilesProvider(_key));
    final isResolving = ref.watch(isResolvingProvider(_key));
    
    final theme = AdditionalWindowTheme.of(context);
    final showDetails = widget.source.hasFileStage && selectedEntry != null;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      expand: false,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: theme.backgroundColor.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.handleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildHeader(showDetails, selectedEntry, theme),
                  const SizedBox(height: 4),
                  Expanded(
                    child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(
                            (child.key == const ValueKey('details-view'))
                                ? 0.08
                                : -0.08,
                            0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: showDetails
                      ? _buildDetailsView(
                    selectedEntry as TEntry,
                    isLoadingFiles,
                    files,
                    selectedResult,
                    theme,
                  )
                      : _buildSearchView(isSearching, results, theme),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (selectedResult == null || isResolving)
                        ? null
                        : _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.addButtonBackground,
                      foregroundColor: theme.addButtonText,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isResolving
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: theme.addButtonText),
                    )
                        : const Text('OK',
                        style: TextStyle(
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ),
          )
        );
      },
    );
  }
}