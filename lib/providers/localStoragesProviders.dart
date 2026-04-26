import 'package:eiga/config/secureStorage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final tokenProvider = AsyncNotifierProvider<TokenNotifier, String>(
  TokenNotifier.new,
);

class TokenNotifier extends AsyncNotifier<String> {

  @override
  Future<String> build() async {
    try {
      return await SecureTokenStorage.getToken();
    } catch (e) {
      return '';
    }
  }

  Future<void> setToken(String apiKey) async {
    if (apiKey.trim().isEmpty) return;

    state = const AsyncValue.loading();
    try {
      await SecureTokenStorage.setToken(apiKey.trim());
      state = AsyncValue.data(apiKey.trim());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteToken() async {
    state = const AsyncValue.loading();

    try {
      await SecureTokenStorage.deleteToken();
      state = const AsyncValue.data('');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

}