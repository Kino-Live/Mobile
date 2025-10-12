import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenStorageService {
  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';

  Future<void> save(String token) => _secure.write(key: _tokenKey, value: token);
  Future<String?> read() => _secure.read(key: _tokenKey);
  Future<void> clear() => _secure.delete(key: _tokenKey);
}
