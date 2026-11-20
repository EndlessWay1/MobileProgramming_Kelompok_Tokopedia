import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileStorage {
  static const _storage = FlutterSecureStorage();

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
    Map<String, String> profile = await _storage.readAll();
    profile.remove('password');
    return profile;
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  static Future<bool> deleteProfile(String email, String password) async {
    String? actualEmail = await _storage.read(key: 'email');
    String? actualPassword = await _storage.read(key: 'password');

    if (actualEmail == email && actualPassword == password) {
      await _storage.deleteAll();
      return true;
    } else {
      return false;
    }
  }
}
