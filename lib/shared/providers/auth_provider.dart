import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/auth_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/local/auth_token_storage.dart';
import 'package:kinolive_mobile/data/sources/local/secure_key_value_storage.dart';
import 'package:kinolive_mobile/data/sources/remote/auth_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';
import 'package:kinolive_mobile/domain/usecases/auth/get_saved_session.dart';
import 'package:kinolive_mobile/domain/usecases/auth/login_user.dart';
import 'package:kinolive_mobile/domain/usecases/auth/logout_user.dart';
import 'package:kinolive_mobile/domain/usecases/auth/register_user.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final keyValueStorageProvider = Provider<SecureKeyValueStorage>((ref) {
  return SecureKeyValueStorage();
});

final accessTokenStorageProvider = Provider<AccessTokenStorage>((ref) {
  final kv = ref.watch(keyValueStorageProvider);
  return AccessTokenStorage(kv);
});

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApiService(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.watch(authApiServiceProvider);
  final storage = ref.watch(accessTokenStorageProvider);
  return AuthRepositoryImpl(api, storage);
});

final loginUserProvider = Provider<LoginUser>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUser(repo);
});

final getSavedSessionProvider = Provider<GetSavedSession>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return GetSavedSession(repo);
});

final logoutUserProvider = Provider<LogoutUser>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LogoutUser(repo);
});

final registerUserProvider = Provider<RegisterUser>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return RegisterUser(repo);
});