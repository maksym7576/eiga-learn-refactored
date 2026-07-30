import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/ui/widgets/phrasesDepacked/phraseDepWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dialogs/AppDialog.dart';

class PhrasesDepPreviewWidget extends ConsumerStatefulWidget {
  const PhrasesDepPreviewWidget({super.key});

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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Preview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.deepPurpleAccent,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _isLoading
                ? 'Loading phrases...'
                : '${_phrasesList.length} phrase${_phrasesList.length == 1 ? '' : 's'} found',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurpleAccent.withValues(alpha: 0.45),
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
    AppDialog.show(
      context: context,
      barrierLabel: "PhraseLabel",
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 6),
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.close, size: 27, color: Colors.black87),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _phrasesList.length,
              itemBuilder: (context, index) =>
                  PhraseDepWidget(phraseObject: _phrasesList[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    List<PhraseObject> tookPhrases = _phrasesList.take(_previewCount).toList();
    return Column(
      children: [
        AnimatedSlide(
          offset: Offset.zero,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: Column(
            children: [
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ...tookPhrases.map((phrase) {
                    return PhraseDepWidget(phraseObject: phrase);
                  }),
                ],
              ),
              GestureDetector(
                onTap: () => _showAllPhrases(context),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurpleAccent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
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
        ),
            ],
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
    );
  }
}
