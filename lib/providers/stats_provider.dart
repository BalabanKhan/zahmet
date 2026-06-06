import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStats {
  final int completedTasks;
  final int postponedTasks;
  final int resetCount;

  UserStats({
    required this.completedTasks,
    required this.postponedTasks,
    required this.resetCount,
  });

  UserStats copyWith({
    int? completedTasks,
    int? postponedTasks,
    int? resetCount,
  }) {
    return UserStats(
      completedTasks: completedTasks ?? this.completedTasks,
      postponedTasks: postponedTasks ?? this.postponedTasks,
      resetCount: resetCount ?? this.resetCount,
    );
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, UserStats>((ref) {
  return StatsNotifier();
});

class StatsNotifier extends StateNotifier<UserStats> {
  final _storage = const FlutterSecureStorage();

  StatsNotifier() : super(UserStats(completedTasks: 0, postponedTasks: 0, resetCount: 0)) {
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final completed = await _storage.read(key: 'stats_completed') ?? '0';
      final postponed = await _storage.read(key: 'stats_postponed') ?? '0';
      final resets = await _storage.read(key: 'stats_resets') ?? '0';

      state = UserStats(
        completedTasks: int.tryParse(completed) ?? 0,
        postponedTasks: int.tryParse(postponed) ?? 0,
        resetCount: int.tryParse(resets) ?? 0,
      );
    } catch (_) {
      try { await _storage.deleteAll(); } catch (_) {}
    }
  }

  Future<void> incrementCompleted() async {
    final newCount = state.completedTasks + 1;
    state = state.copyWith(completedTasks: newCount);
    try { await _storage.write(key: 'stats_completed', value: newCount.toString()); } catch (_) {
      try { await _storage.deleteAll(); } catch (_) {}
    }
  }

  Future<void> incrementPostponed() async {
    final newCount = state.postponedTasks + 1;
    state = state.copyWith(postponedTasks: newCount);
    try { await _storage.write(key: 'stats_postponed', value: newCount.toString()); } catch (_) {
      try { await _storage.deleteAll(); } catch (_) {}
    }
  }

  Future<void> incrementResetCount() async {
    final newCount = state.resetCount + 1;
    state = state.copyWith(resetCount: newCount);
    try { await _storage.write(key: 'stats_resets', value: newCount.toString()); } catch (_) {
      try { await _storage.deleteAll(); } catch (_) {}
    }
  }
}
