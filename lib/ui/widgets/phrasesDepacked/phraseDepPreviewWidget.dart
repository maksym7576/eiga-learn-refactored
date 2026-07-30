import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/ui/widgets/phrasesDepacked/phraseDepWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhrasesDepPreviewWidget extends ConsumerStatefulWidget {
  final VoidCallback? onSearch;
  const PhrasesDepPreviewWidget({super.key, this.onSearch});

  @override
  ConsumerState<PhrasesDepPreviewWidget> createState() =>
      _PhrasesDepPreviewWidgetState();
}

class _PhrasesDepPreviewWidgetState
    extends ConsumerState<PhrasesDepPreviewWidget> {
  final int _previewCount = 5;
  List<PhraseObject> _phrasesList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPhrasesIfReady();
    });
  }

  Future<void> _loadPhrasesIfReady() async {
    final languageState = ref.read(languageProvider);
    final srtPath = ref.read(srtPathProvider);

    if (languageState.original.isNotEmpty &&
        srtPath != null &&
        srtPath.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _phrasesList = [];
      });

      try {
        final List<PhraseObject> newPhrases = await _fetchPhraseList(
          languageState.original,
          srtPath,
        );

        setState(() {
          _phrasesList = newPhrases;
        });
      } catch (e) {
        setState(() {
          _phrasesList = [];
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _phrasesList = [];
        _isLoading = false;
      });
    }
  }

  Future<List<PhraseObject>> _fetchPhraseList(
    String originalLanguage,
    String srtPath,
  ) async {
    try {
      final depackService = ref.read(subtitleDepackerServiceProvider);
      final result = await depackService.parseSrtPreview(
        filePath: srtPath,
        language: originalLanguage,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Phrases Preview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepPurpleAccent,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isLoading
                      ? 'Loading...'
                      : '${_phrasesList.length} phrases found',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurpleAccent.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          if (widget.onSearch != null)
            IconButton(
              onPressed: widget.onSearch,
              icon: const Icon(Icons.search, color: Colors.deepPurpleAccent),
              tooltip: 'Search subtitles',
              style: IconButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurpleAccent,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'No phrases found',
          style: TextStyle(
            fontSize: 14,
            color: Colors.deepPurple.withValues(alpha: 0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showAllPhrases(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.98,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 48),
                      child: Text(
                        'All Phrases',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.deepPurpleAccent,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 28),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _phrasesList.length,
                  itemBuilder: (context, index) =>
                      PhraseDepWidget(phraseObject: _phrasesList[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    List<PhraseObject> tookPhrases = _phrasesList.take(_previewCount).toList();
    return Column(
      children: [
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            ...tookPhrases.map((phrase) {
              return PhraseDepWidget(phraseObject: phrase);
            }),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurpleAccent.withValues(alpha: 0.4)),
            ),
            child: const Text(
              'See more',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(languageProvider, (previous, next) {
      _loadPhrasesIfReady();
    });

    ref.listen(srtPathProvider, (previous, next) {
      _loadPhrasesIfReady();
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: () => _showAllPhrases(context),
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              if (_isLoading) _buildLoader(),
              if (!_isLoading && _phrasesList.isEmpty) _buildEmpty(),
              if (!_isLoading && _phrasesList.isNotEmpty) _buildList(context),
            ],
          ),
        ),
      ),
    );
  }
}
