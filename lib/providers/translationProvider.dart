import 'dart:async';

import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TranslationProvider {
  final Ref ref;

  int? _currentVideoId;
  Timer? _jumperTimer;
  bool _isProcessing = false;

  TranslationProvider(this.ref) {
    _initListeners();
  }

  void _initListeners() {
    ref.listen<int?>(playerIdProvider, (prev, nextVideoId) {
      if (nextVideoId != _currentVideoId) {
        _resetState(nextVideoId);
      }
    });

    ref.listen<Duration?>(playerTimeProvider, (prevTime, currentTime) {
      if (currentTime != null && _currentVideoId != null) {
        _handleTimeUpdate(prevTime, currentTime);
      }
    });

    final initialVideoId = ref.read(playerIdProvider);
    if (initialVideoId != null) {
      _resetState(initialVideoId);
    }
  }

  void _resetState(int? newVideoId) {
    _jumperTimer?.cancel();
    _isProcessing = false;
    _currentVideoId = newVideoId;
  }

  void _handleTimeUpdate(Duration? prevTime, Duration currentTime) {
    if (prevTime == null) {
      _checkAndTranslate(currentTime);
      return;
    }
    final diff = (currentTime - prevTime).abs();

    if (diff > const Duration(seconds: 3)) {
      _jumperTimer?.cancel();
      _jumperTimer = Timer(const Duration(seconds: 2), () {
        _checkAndTranslate(currentTime);
      });
    } else {
      _jumperTimer?.cancel();
      _checkAndTranslate(currentTime);
    }
  }

  Future<void> _checkAndTranslate(Duration currentTime) async {
    if (_isProcessing || _currentVideoId == null) return;

    final allPhrases = ref.read(phraseListProvider(_currentVideoId!)).value ?? [];
    if (allPhrases.isEmpty) return;

    final pastPhrase = <PhraseObject>[];
    final futurePhrases = <PhraseObject>[];
    
    for (var phrase in allPhrases) {
      if (phrase.isTranslating == true || phrase.isTranslated == true) continue;
      
      final phraseTime = _toDuration(phrase.startTime!);
      if (phraseTime < currentTime) {
        pastPhrase.add(phrase);
      } else {
        futurePhrases.add(phrase);
      }
    }

    if (futurePhrases.isNotEmpty) {
      final config = ref.read(appConfigsProvider);
      final lookAhead = Duration(seconds: config.getSecondsAhead);
      final nextPhraseTime = _toDuration(futurePhrases.first.startTime!);

      if (nextPhraseTime <= currentTime + lookAhead) {
        final playLoad = _buildPlayLoad(pastPhrase, futurePhrases, config.getNumberOfPhrases);
        await _sendToApi(playLoad);
      }
    }
  }

  List<PhraseObject> _buildPlayLoad(List<PhraseObject> past, List<PhraseObject> future, int maxLimit) {
      final result = <PhraseObject>[];

      final recentPast = past.length > 5 ? past.sublist(past.length - 5) : past;
      result.addAll(recentPast);

      final remainingSpace = maxLimit - result.length;
      if (remainingSpace > 0) {
        result.addAll(future.take(remainingSpace));
      }
      return result;
  }
  
  Future<void> _sendToApi(List<PhraseObject> phrases) async {
    if (phrases.isEmpty || _isProcessing) return;
    
    _isProcessing = true;
    
    try {
      final video = await ref.read(videoServiceProvider).getVideoById(phrases.first.videoId!);
      if (video == null) return;
      await ref.read(phraseServiceProvider).markPhrasesAsTranslatingByPhraseList(phrases);
      await ref.read(geminiServiceProvider).translatePhraseList(phraseObjectsList: phrases, originalLanguage: video.originalLanguage, translationLanguage: video.translatedLanguage!);
    } catch (e) {
      print('Translation APi Error: $e');
    } finally {
      _isProcessing = false;
    }
  }
  
  Duration _toDuration(DateTime time) {
    return Duration(
      hours: time.hour,
      minutes: time.minute,
      seconds:  time.second,
      milliseconds: time.millisecond,
    );
  }
}