import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveProfile({
    required String username,
    required String email,
    required String password,
    required String location,
  }) async {
    await _storage.write(key: 'username', value: username);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
    await _storage.write(key: 'location', value: location);
  }

  static Future<Map<String, String>> getProfile() async {
    return await _storage.readAll();
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }
}
