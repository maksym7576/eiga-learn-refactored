
import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:eiga/providers/packageProviders.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReadingTypeProvider {
  final ReadingTypeLanguageConfig config;
  final String mainOption;
  final String? additionalOptions;

  ReadingTypeProvider({
    required this.config,
    this.mainOption = 'original',
    this.additionalOptions,
  });

  ReadingTypeProvider copyWith({
    ReadingTypeLanguageConfig? config,
    String? mainOption,
    String? Function()? additionalOption,
  }) {
    return ReadingTypeProvider(
      config: config ?? this.config,
      mainOption: mainOption ?? this.mainOption,
      additionalOptions:
          additionalOption != null ? additionalOption() : additionalOptions,
    );
  }
}

class ReadingTypeNotifier
    extends AutoDisposeAsyncNotifier<ReadingTypeProvider> {
  String _getMainKey(String lang) => 'reading_main_$lang';
  String _getAdditionalKey(String lang) => 'reading_additional_$lang';

  @override
  Future<ReadingTypeProvider> build() async {
    final videoId = ref.watch(playerIdProvider);
    if (videoId == null) throw Exception('Video ID is null');

    final video =
        await ref.read(videoServiceProvider.notifier).getVideoById(videoId);
    if (video == null || video.originalLanguage == null) {
      throw Exception('Video or language not found');
    }

    final lang = video.originalLanguage!.toLowerCase();
    final languageConfig = ReadingTypeLanguageConfigRegistry.getConfing(lang);

    final prefs = ref.read(sharedPreferencesProvider);
    final savedMain = prefs.getString(_getMainKey(lang)) ?? 'original';
    final savedAdditional = prefs.getString(_getAdditionalKey(lang));

    return ReadingTypeProvider(
      config: languageConfig,
      mainOption: savedMain,
      additionalOptions: savedAdditional,
    );
  }

  Future<void> updateAdditionalOption(String? newAdditional) async {
    if (state.hasValue) {
      final val = state.value!;
      final videoId = ref.read(playerIdProvider);
      final video =
          await ref.read(videoServiceProvider.notifier).getVideoById(videoId!);
      final lang = video?.originalLanguage?.toLowerCase() ?? 'default';

      final prefs = ref.read(sharedPreferencesProvider);
      if (newAdditional == null) {
        await prefs.remove(_getAdditionalKey(lang));
      } else {
        await prefs.setString(_getAdditionalKey(lang), newAdditional);
      }

      state = AsyncData(val.copyWith(
        additionalOption: () => newAdditional,
      ));
    }
  }

  Future<void> updateMainOption(String newMainOption) async {
    if (state.hasValue) {
      final val = state.value!;
      final videoId = ref.read(playerIdProvider);
      final video =
          await ref.read(videoServiceProvider.notifier).getVideoById(videoId!);
      final lang = video?.originalLanguage?.toLowerCase() ?? 'default';

      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString(_getMainKey(lang), newMainOption);

      state = AsyncData(val.copyWith(
        mainOption: newMainOption,
      ));
    }
  }
}
