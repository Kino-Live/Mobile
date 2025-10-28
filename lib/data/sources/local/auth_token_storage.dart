import 'package:kinolive_mobile/data/sources/local/secure_key_value_storage.dart';

class AccessTokenStorage {
  static const _key = 'access_token';

  final SecureKeyValueStorage _storage;
  const AccessTokenStorage(this._storage);

  Future<void> save(String token) => _storage.save(_key, token);
  Future<String?> read() => _storage.read(_key);
  Future<void> clear() => _storage.clear(_key);
}

// class RefreshTokenStorage {
//   static const _key = 'refresh_token';
//
//   final SecureKeyValueStorage _storage;
//   const RefreshTokenStorage(this._storage);
//
//   Future<void> save(String token) => _storage.save(_key, token);
//   Future<String?> read() => _storage.read(_key);
//   Future<void> clear() => _storage.clear(_key);
// }
