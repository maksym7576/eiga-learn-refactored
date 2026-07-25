import 'package:eiga/config/secureStorage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final tokenProvider = AsyncNotifierProvider.family<TokenNotifier, String, ApiTokenType>(
  TokenNotifier.new,
);

class TokenNotifier extends FamilyAsyncNotifier<String, ApiTokenType> {

  @override
  Future<String> build(ApiTokenType arg) async {
    try {
      return await SecureTokenStorage.getToken(arg);
    } catch (e) {
      return '';
    }
  }

  Future<void> setToken(String apiKey) async {
    final trimmedKey = apiKey.trim();
    if (apiKey.trim().isEmpty) return;

    state = const AsyncValue.loading();
    try {
      await SecureTokenStorage.setToken(arg,trimmedKey);
      state = AsyncValue.data(trimmedKey);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteToken() async {
    state = const AsyncValue.loading();

    try {
      await SecureTokenStorage.deleteToken(arg);
      state = const AsyncValue.data('');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

}