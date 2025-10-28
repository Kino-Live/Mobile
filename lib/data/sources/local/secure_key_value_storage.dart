import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureKeyValueStorage {
  final FlutterSecureStorage _secure;
  const SecureKeyValueStorage([FlutterSecureStorage? secure])
      : _secure = secure ?? const FlutterSecureStorage();

  Future<void> save(String key, String value) => _secure.write(key: key, value: value);
  Future<String?> read(String key) => _secure.read(key: key);
  Future<void> clear(String key) => _secure.delete(key: key);
}
