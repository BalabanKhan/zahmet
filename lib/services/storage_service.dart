import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const _tripScoreKey = 'trip_score';

  static Future<int> getTripScore() async {
    final value = await _storage.read(key: _tripScoreKey);
    if (value != null) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static Future<void> saveTripScore(int score) async {
    await _storage.write(key: _tripScoreKey, value: score.toString());
  }
}
