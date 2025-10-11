import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kinolive_mobile/data/sources/local/auth_token_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
      (ref) => const FlutterSecureStorage(),
);

final authTokenStorageProvider = Provider<AuthTokenStorage>(
      (ref) => AuthTokenStorage(ref.read(secureStorageProvider)),
);

final authTokenProvider =
NotifierProvider<AuthTokenController, String?>(() => AuthTokenController());

class AuthTokenController extends Notifier<String?> {
  @override
  String? build() {
    scheduleMicrotask(() async {
      final saved = await ref.read(authTokenStorageProvider).read();
      if (saved != state) state = saved;
    });
    return null;
  }

  Future<void> setToken(String token) async {
    await ref.read(authTokenStorageProvider).save(token);
    state = token;
  }

  Future<void> clearToken() async {
    await ref.read(authTokenStorageProvider).clear();
    state = null;
  }
}

final isAuthenticatedProvider = Provider<bool>((ref) {
  final token = ref.watch(authTokenProvider);
  return token != null && token.isNotEmpty;
});
