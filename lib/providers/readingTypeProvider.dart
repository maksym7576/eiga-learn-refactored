

import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
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
    this.additionalOptions
});

  ReadingTypeProvider copyWith({
    ReadingTypeLanguageConfig? config,
    String? mainOption,
    String? Function()? additionalOption,
}) {
    return ReadingTypeProvider(
        config: config ?? this.config,
        mainOption: mainOption ?? this.mainOption,
        additionalOptions: additionalOption != null ? additionalOption() : additionalOptions,
    );
  }
}

class ReadingTypeNotifier extends AutoDisposeAsyncNotifier<ReadingTypeProvider> {
  @override
  Future<ReadingTypeProvider> build() async {
    final videoId = ref.watch(playerIdProvider);

    final video = await ref.read(videoServiceProvider.notifier).getVideoById(videoId!);

    final languageConfig = ReadingTypeLanguageConfigRegistry.getConfing(video!.originalLanguage);

    return ReadingTypeProvider(
        config: languageConfig,
        mainOption: 'original',
        additionalOptions: null,
    );
  }
  
  void updateAdditionalOption(String? newAdditional) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(
        additionalOption: () => newAdditional,
      ));
    }
  }

  void updateMainOption(String newMainOption) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(mainOption: newMainOption,
      ));
    }
  }
}