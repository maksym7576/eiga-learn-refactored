

import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageState {
  final String original;
  final String target;

  const LanguageState({
    this.original = '',
    this.target = '',
});

  LanguageState copyWith({String? original, String? target}) => LanguageState(
    original: original ?? this.original,
    target: target ?? this.target,
  );
}


class LanguageNotifier extends Notifier<LanguageState> {
  @override
  LanguageState build() => const LanguageState();

  void setOriginal(String language) =>
      state = state.copyWith(original: language);

  void setTarget(String language) =>
      state = state.copyWith(target: language);
}

final languageProvider = NotifierProvider<LanguageNotifier, LanguageState>(LanguageNotifier.new);