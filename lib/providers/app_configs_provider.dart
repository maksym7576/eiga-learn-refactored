import 'package:eiga/config/appConfigs.dart';
import 'package:eiga/providers/packageProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppConfigsState {
  final int secondsAhead;
  final int numberOfPhrases;

  AppConfigsState({required this.secondsAhead, required this.numberOfPhrases});

  AppConfigsState copyWith({int? secondsAhead, int? numberOfPhrases}) {
    return AppConfigsState(
      secondsAhead: secondsAhead ?? this.secondsAhead,
      numberOfPhrases: numberOfPhrases ?? this.numberOfPhrases,
    );
  }
}

class AppConfigsNotifier extends AutoDisposeAsyncNotifier<AppConfigsState> {
  @override
  Future<AppConfigsState> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    final configs = AppConfigs(prefs);
    return AppConfigsState(
      secondsAhead: configs.getSecondsAhead,
      numberOfPhrases: configs.getNumberOfPhrases,
    );
  }

  Future<void> updateSecondsAhead(int value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final configs = AppConfigs(prefs);
    await configs.setSecondsAhead(value);
    state = AsyncData(state.value!.copyWith(secondsAhead: value));
  }

  Future<void> updateNumberOfPhrases(int value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final configs = AppConfigs(prefs);
    await configs.setNumberOfPhrases(value);
    state = AsyncData(state.value!.copyWith(numberOfPhrases: value));
  }

  Future<void> resetToDefault() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final configs = AppConfigs(prefs);
    await configs.resetToDefault();
    state = AsyncData(AppConfigsState(
      secondsAhead: 100,
      numberOfPhrases: 40,
    ));
  }
}

final appConfigsNotifierProvider =
    AsyncNotifierProvider.autoDispose<AppConfigsNotifier, AppConfigsState>(
  AppConfigsNotifier.new,
);
