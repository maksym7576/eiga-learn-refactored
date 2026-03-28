import 'package:eiga/backend/services/models_services/blockService.dart';
import 'package:eiga/backend/services/geminiService.dart';
import 'package:eiga/backend/services/models_services/phraseService.dart';
import 'package:eiga/backend/services/models_services/videoService.dart';
import 'package:eiga/backend/services/models_services/wordService.dart';
import 'package:eiga/config/appConfigs.dart';
import 'package:eiga/config/modelsUrl/aiModelManager.dart';
import 'package:eiga/providers/modelsProviders.dart';
import 'package:eiga/providers/packageProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final appConfigsProvider = Provider<AppConfigs>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return AppConfigs(prefs);
});

final phraseServiceProvider = Provider<PhraseService>((ref) {
  final db = ref.watch(isarProvider);
  return PhraseService(db);
});

final videoServiceProvider = Provider<VideoService>((ref) {
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


final geminiServiceProvider = Provider<GeminiService>((ref) {
  final phraseService = ref.read(phraseServiceProvider);
  final blockService = ref.read(blockServiceProvider);
  final wordService = ref.read(wordServiceProvider);
  return GeminiService(phraseService: phraseService, blockService: blockService, wordService: wordService);
});

