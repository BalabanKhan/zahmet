import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

enum TripState { normal, passiveAggressive, aestheticTorture, locked }

class TripNotifier extends StateNotifier<int> {
  TripNotifier() : super(0) {
    _loadScore();
  }

  Future<void> _loadScore() async {
    final score = await StorageService.getTripScore();
    state = score;
  }

  Future<void> _saveAndSet(int newScore) async {
    int bounded = newScore.clamp(0, 100);
    await StorageService.saveTripScore(bounded);
    state = bounded;
  }

  void increaseScore(int amount) => _saveAndSet(state + amount);
  void decreaseScore(int amount) => _saveAndSet(state - amount);
  void resetScore() => _saveAndSet(0);

  TripState get tripState {
    if (state >= 95) return TripState.locked;
    if (state >= 70) return TripState.aestheticTorture;
    if (state >= 30) return TripState.passiveAggressive;
    return TripState.normal;
  }
}

final tripProvider = StateNotifierProvider<TripNotifier, int>((ref) {
  return TripNotifier();
});
