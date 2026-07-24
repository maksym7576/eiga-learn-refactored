import 'dart:async';

import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/providers/phraseListProvider.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:eiga/providers/AIRequestStatusProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../backend/services/AiService.dart';

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
      // Пропускаємо ті, що вже в процесі або вже перекладені
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
      // Очікуємо, що config має геттери getSecondsAhead та getNumberOfPhrases
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

    final aiStatus = ref.read(aiRequestStatusProvider.notifier);
    try {
      final video = await ref.read(videoServiceProvider.notifier).getVideoById(phrases.first.videoId!);
      if (video == null) {
        aiStatus.appendLog('TranslationProvider: video not found for phrase ${phrases.first.id}');
        return;
      }

      // Помітити фрази як "translating"
      try {
        await ref.read(phraseServiceProvider).markPhrasesAsTranslatingByPhraseList(phrases);
      } catch (e) {
        aiStatus.appendLog('TranslationProvider: failed to mark phrases as translating: $e');
      }

      final aiService = ref.read(aiServiceProvider);
      final defaultTransport = ref.read(defaultAiTransportProvider);

      // Виклик основного сервісу з вибором транспорту
      await aiService.translatePhraseList(
        phraseObjectsList: phrases,
        originalLanguage: video.originalLanguage!,
        translationLanguage: video.translatedLanguage!,
        transportName: defaultTransport,
      );
    } catch (e, st) {
      // Лог та репорт у провайдер статусу
      ref.read(aiRequestStatusProvider.notifier).appendLog('TranslationProvider error: $e');
      ref.read(aiRequestStatusProvider.notifier).reportError(e, message: e.toString(), stackTrace: st, terminal: false);

      // Спроба зняти мітку "translating" якщо було помилково встановлено
      try {
        await ref.read(phraseServiceProvider).markPhrasesAsTranslatingByPhraseList(phrases);
      } catch (_) {
        // якщо метода немає або він падає — просто логнемо
        ref.read(aiRequestStatusProvider.notifier).appendLog('TranslationProvider: failed to unmark phrases after error');
      }

      print('Translation API Error: $e\n$st');
    } finally {
      _isProcessing = false;
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