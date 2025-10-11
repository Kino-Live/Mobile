import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/auth_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/local/auth_token_storage.dart';
import 'package:kinolive_mobile/data/sources/remote/auth_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';
import 'package:kinolive_mobile/domain/usecases/login/login_user.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final authTokenStorageProvider =
Provider<AuthTokenStorageService>((ref) => AuthTokenStorageService());

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthApiService(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.read(authApiServiceProvider);
  final storage = ref.read(authTokenStorageProvider);
  return AuthRepositoryImpl(api, storage);
});

final loginUserProvider = Provider<LoginUser>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUser(repo);
});