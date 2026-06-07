import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const _tripScoreKey = 'trip_score';

  static Future<int> getTripScore() async {
    try {
      final value = await _storage.read(key: _tripScoreKey);
      if (value != null) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    } catch (e) {
      try { await _storage.deleteAll(); } catch (_) {}
      return 0;
    }
  }

  static Future<void> saveTripScore(int score) async {
    try {
      await _storage.write(key: _tripScoreKey, value: score.toString());
    } catch (e) {
      try { await _storage.deleteAll(); } catch (_) {}
      try { await _storage.write(key: _tripScoreKey, value: score.toString()); } catch (_) {}
    }
  }
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      try { await _storage.deleteAll(); } catch (_) {}
      try { await _storage.write(key: key, value: value); } catch (_) {}
    }
  }

  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      try { await _storage.deleteAll(); } catch (_) {}
      return null;
    }
  }

  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (_) {}
  }
}
