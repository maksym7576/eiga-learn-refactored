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
            .showSnackBar(SnackBar(content: Text('Помилка пошуку: $e')));
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
            SnackBar(content: Text('Помилка завантаження деталей: $e')));
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
            .showSnackBar(SnackBar(content: Text('Помилка: $e')));
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

  Widget _buildHeader(bool showDetails, TEntry? selectedEntry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              if (showDetails)
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.deepPurpleAccent),
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
                          color: Colors.deepPurpleAccent.withValues(alpha: 0.5),
                        ),
                      ),
                    Text(
                      showDetails
                          ? widget.source.entryLabel(selectedEntry as TEntry)
                          : widget.source.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurpleAccent,
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
          child: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.close, size: 24, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchView(bool isSearching, List<TEntry> results) {
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
                  decoration: InputDecoration(
                    hintText: widget.source.searchHint,
                    filled: true,
                    fillColor: Colors.grey.shade100,
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
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: isSearching
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Icon(Icons.search,
                      color: Colors.white, size: 20),
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
                style: TextStyle(color: Colors.black.withValues(alpha: 0.4))),
          )
              : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final entry = results[index];
              return widget.source.buildEntryCard(
                entry,
                false, // на сторінці пошуку нема сенсу підсвічувати "активний" —
                // тап одразу веде на іншу сторінку
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
      ) {
    return Column(
      key: const ValueKey('details-view'),
      children: [
        widget.source.buildEntryCard(entry, true, _goBack),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Divider(height: 1),
        ),
        Expanded(
          child: isLoadingFiles
              ? const Center(child: CircularProgressIndicator())
              : files.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Нічого не знайдено',
                style:
                TextStyle(color: Colors.black.withValues(alpha: 0.4))),
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

    // "друга сторінка" показується тільки якщо джерело двоетапне і щось обрано
    final showDetails = widget.source.hasFileStage && selectedEntry != null;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 6),
              _buildHeader(showDetails, selectedEntry),
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
                  )
                      : _buildSearchView(isSearching, results),
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
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isResolving
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                        : const Text('OK',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}