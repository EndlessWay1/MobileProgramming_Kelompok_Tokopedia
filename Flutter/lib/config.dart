import 'package:flutter/foundation.dart';

class AppConfig {
  // Bisa di-override saat run, contoh untuk HP fisik:
  // flutter run --dart-define=API_BASE_URL=http://192.168.1.10:5000
  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;

    // Android emulator: localhost = emulator itu sendiri, komputer = 10.0.2.2
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }

    // Web, iOS simulator, Windows/macOS/Linux desktop
    return 'http://localhost:5000';
  }
}