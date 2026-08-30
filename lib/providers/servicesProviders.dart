import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/backend/services/depack_subtitles_services/subtitleDepackerService.dart';
import 'package:eiga/backend/services/models_services/blockService.dart';
import 'package:eiga/backend/services/models_services/phraseService.dart';
import 'package:eiga/backend/services/models_services/videoService.dart';
import 'package:eiga/backend/services/models_services/wordService.dart';
import 'package:eiga/backend/services/petition_ai/parsers/PhraseResponseHandler.dart';
import 'package:eiga/backend/services/system/databaseMaintenanceService.dart';
import 'package:eiga/config/appConfigs.dart';
import 'package:eiga/providers/modelsProviders.dart';
import 'package:eiga/providers/packageProviders.dart';
import 'package:eiga/providers/translationProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../backend/services/AiService.dart';
import '../backend/services/AniListService.dart';
import '../backend/services/JimakuService.dart';
import '../backend/services/petition_ai/gemini/GeminiHTTPService.dart';
import '../backend/services/petition_ai/gemini/geminiStreamingService.dart';


final appConfigsProvider = Provider<AppConfigs>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppConfigs(prefs);
});

final phraseServiceProvider = Provider<PhraseService>((ref) {
  final db = ref.watch(isarProvider);
  return PhraseService(db);
});

final videoServiceProvider = StateNotifierProvider<VideoService, List<VideoObject>>((ref) {
  final db = ref.watch(isarProvider);
  return VideoService(db);
});

final blockServiceProvider = Provider<BlockService>((ref) {
  final db = ref.watch(isarProvider);
  return BlockService(db);
});

final wordServiceProvider = Provider<WordService>((ref) {
  final db = ref.watch(isarProvider);
  return WordService(db);
});

final databaseMaintenanceServiceProvider = Provider<DatabaseMaintenanceService>((ref) {
  final db = ref.watch(isarProvider);
  return DatabaseMaintenanceService(db);
});

final jimakuServiceProvider = FutureProvider<JimakuService>((ref) async {
  return JimakuService.create();
});

final subtitleDepackerServiceProvider = Provider<SubtitleDepackerService>((ref) {
  final videoService = ref.watch(videoServiceProvider.notifier);
  final phraseService = ref.watch(phraseServiceProvider);

  return SubtitleDepackerService(videoService: videoService, phraseService: phraseService);
});

final translationProvider = Provider<TranslationProvider>((ref) {
  final service = TranslationProvider(ref);
  return service;
});

final aniListServiceProvider = Provider<AniListService>((ref) {
  return AniListService();
});

final geminiHTTPServiceProvider = Provider<GeminiHTTPService>((ref) {
  final phraseResponseHandler = PhraseResponseHandler(
    phraseService: ref.watch(phraseServiceProvider),
    blockService: ref.watch(blockServiceProvider),
    wordService: ref.watch(wordServiceProvider),
  );

  return GeminiHTTPService(
    phraseResponseHandler: phraseResponseHandler,
  );
});


final phraseResponseHandlerProvider = Provider<PhraseResponseHandler>((ref) {
  final phraseService = ref.watch(phraseServiceProvider);
  final blockService = ref.watch(blockServiceProvider);
  final wordService = ref.watch(wordServiceProvider);

  return PhraseResponseHandler(
    phraseService: phraseService,
    blockService: blockService,
    wordService: wordService,
  );
});

// Провайдер для Gemini Streaming сервісу
final geminiStreamingServiceProvider = Provider<GeminiStreamingService>((ref) {
  final phraseResponseHandler = ref.watch(phraseResponseHandlerProvider);

  return GeminiStreamingService(
    phraseResponseHandler: phraseResponseHandler,
  );
});
// Провайдер для AiService
final aiServiceProvider = Provider<AiService>((ref) {
  final geminiStream = ref.watch(geminiStreamingServiceProvider);

  return AiService(
    ref: ref,
    geminiStreamingService: geminiStream,
  );
});