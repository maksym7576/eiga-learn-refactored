import 'dart:async';

import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/exeption/geminiException.dart';
import 'package:eiga/providers/AiRequestPhase.dart';
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
      print('TranslationProvider: listener initialized for video $_currentVideoId -> $nextVideoId');
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
      final lookAhead = Duration(seconds: (config as dynamic).getSecondsAhead as int? ?? 5);
      final nextPhraseTime = _toDuration(futurePhrases.first.startTime!);

      if (nextPhraseTime <= currentTime + lookAhead) {
        final playLoad = _buildPlayLoad(pastPhrase, futurePhrases, (config as dynamic).getNumberOfPhrases as int? ?? 8);
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
      final video = await ref.read(videoServiceProvider.notifier).getVideoById(phrases.first.videoId!);
      if (video == null) {
        print('TranslationProvider: video not found for phrase ${phrases.first.id}');
        return;
      }

      try {
        await ref.read(phraseServiceProvider).markPhrasesAsTranslatingByPhraseList(phrases);
      } catch (e) {
      }

      final aiService = ref.read(aiServiceProvider);

      // Маршрутизація по video.pepelineIndetificator відбувається всередині
      // runTranslationForVideo — TranslationProvider більше не знає і не має
      // знати, який саме пайплайн (total_v1 / context_translation_v1) буде викликано.
      final result = await aiService.runTranslationForVideo(
        ref: ref,
        video: video,
        phraseObjectsList: phrases,
        originalLanguage: video.originalLanguage!,
        translationLanguage: video.translatedLanguage!,
      );

      if (!result.isOk) {
        ref.read(aiRequestResultProvider.notifier).state = result;
      }
    } catch (e, st) {
      if (e is GeminiException) {
        ref.read(aiRequestResultProvider.notifier).state = AiRequestResult.failure(e.type);
        try {
          await ref.read(phraseServiceProvider).resetPhrasesTranslationStatus(phrases);
        } catch (_) {}
      } else {
        try {
          await ref.read(phraseServiceProvider).markPhrasesAsTranslatingByPhraseList(phrases);
        } catch (_) {}
      }

      print('Translation API Error: $e\n$st');
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> retryPhrases(List<int> phraseIds) async {
    if (phraseIds.isEmpty || _isProcessing) return;
    
    final phrases = <PhraseObject>[];
    for (final id in phraseIds) {
      final p = await ref.read(phraseServiceProvider).getPhraseById(id);
      if (p != null) phrases.add(p);
    }
    
    if (phrases.isNotEmpty) {
      await _sendToApi(phrases);
    }
  }

  Duration _toDuration(DateTime time) {
    return Duration(
      hours: time.hour,
      minutes: time.minute,
      seconds: time.second,
      milliseconds: time.millisecond,
    );
  }
}