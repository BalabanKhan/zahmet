import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import '../services/nlp_service.dart';
import 'trip_provider.dart';
import 'stats_provider.dart';
import '../l10n/app_texts.dart';

class AddTaskResponse {
  final String? whisperMessage;
  final String? snackBarMessage;
  final bool isEndgame;

  AddTaskResponse({
    this.whisperMessage,
    this.snackBarMessage,
    this.isEndgame = false,
  });
}

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final Ref ref;
  final _storage = const FlutterSecureStorage();
  
  TaskNotifier(this.ref) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final now = DateTime.now();
    bool needsUpdate = false;

    if (kIsWeb) {
      for (var t in DatabaseService.webMockTasks) {
        if (t.isPostponed && !t.isDeleted) {
          final pDate = t.postponedAt ?? t.createdAt;
          if (now.difference(pDate).inDays >= 1 || now.day != pDate.day) {
            t.isPostponed = false;
            t.text = "[DÜN YALAN SÖYLEDİN] ${t.text.replaceFirst('hayal: ', '')}";
            needsUpdate = true;
          }
        }
      }
      state = DatabaseService.webMockTasks.where((t) => !t.isDeleted).toList();
      state.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      return;
    }

    final tasks = await DatabaseService.isar!.taskModels.where().filter().isDeletedEqualTo(false).sortByOrderIndex().findAll();
    
    await DatabaseService.isar!.writeTxn(() async {
      for (var t in tasks) {
        if (t.isPostponed) {
          final pDate = t.postponedAt ?? t.createdAt;
          if (now.difference(pDate).inDays >= 1 || now.day != pDate.day) {
            t.isPostponed = false;
            t.text = "[BUGÜN YAPACAKTIN] ${t.text.replaceFirst('hayal: ', '')}";
            await DatabaseService.isar!.taskModels.put(t);
            needsUpdate = true;
          }
        }
      }
    });

    if (needsUpdate) {
      state = await DatabaseService.isar!.taskModels.where().filter().isDeletedEqualTo(false).sortByOrderIndex().findAll();
    } else {
      state = tasks;
    }
  }

  final List<DateTime> _addTimestamps = [];

  Future<AddTaskResponse> addTask(String text) async {
    final now = DateTime.now();

    // NLP Analysis
    final nlpResult = NlpService.analyzeTaskSubmission(text, now);

    if (nlpResult.isEndgame) {
      return AddTaskResponse(isEndgame: true);
    }

    if (nlpResult.shouldBlock) {
      return AddTaskResponse(
        whisperMessage: nlpResult.whisperMessage,
        snackBarMessage: nlpResult.snackBarMessage,
      );
    }

    String finalTxt = nlpResult.processedText;
    String? kekstraMessage = nlpResult.snackBarMessage;
    String? whisperMessage = nlpResult.whisperMessage;

    // Kekstra 39: Panic Attack
    _addTimestamps.add(now);
    _addTimestamps.removeWhere((t) => now.difference(t).inSeconds > 30);
    if (_addTimestamps.length >= 8) {
      return AddTaskResponse(whisperMessage: AppTexts.kekstraPanicAttack);
    }

    // Kekstra 37 & 13: Reincarnation & Dejavu
    if (!kIsWeb) {
      final oldTasks = await DatabaseService.isar!.taskModels.where().filter()
          .textEqualTo(finalTxt)
          .isDeletedEqualTo(true)
          .findAll();
      if (oldTasks.isNotEmpty) {
        final old = oldTasks.last;
        final deletedDiff = old.deletedAt != null ? now.difference(old.deletedAt!).inSeconds : 999;
        final createdDiff = now.difference(old.createdAt).inDays;
        
        if (deletedDiff < 60 && createdDiff >= 14) {
          kekstraMessage = AppTexts.kekstraReincarnation;
        } else if (old.deletedAt != null && now.difference(old.deletedAt!).inDays > 10) {
          kekstraMessage = AppTexts.kekstraDejavu;
        }
      }
    }

    // Kekstra 23: Micro Tasks
    final recentTasks = state.where((t) => now.difference(t.createdAt).inSeconds < 60).toList();
    if (recentTasks.length >= 3) {
      for (var t in recentTasks) {
        await _deleteTaskHard(t.id);
      }
      finalTxt = "odayı topla vizyonsuz";
      kekstraMessage = AppTexts.kekstraMicroTask;
    }

    final tripState = ref.read(tripProvider.notifier).tripState;
    if (tripState == TripState.passiveAggressive || tripState == TripState.aestheticTorture) {
      finalTxt = NlpService.analyzeAndReact(finalTxt);
    }

    final task = TaskModel()
      ..text = finalTxt
      ..createdAt = now
      ..orderIndex = state.length;
    
    if (kIsWeb) {
      task.id = now.millisecondsSinceEpoch;
      DatabaseService.webMockTasks.add(task);
    } else {
      await DatabaseService.isar!.writeTxn(() async {
        await DatabaseService.isar!.taskModels.put(task);
      });
    }
    
    await _loadTasks();
    
    String? hasSeen = await _storage.read(key: 'hasSeenEndgame');
    if (hasSeen == 'true') {
      await _storage.write(key: 'hasSeenEndgame', value: 'acknowledged');
      await _storage.write(key: 'totalCompleted', value: '0');
      kekstraMessage = AppTexts.endgamePost;
    }

    return AddTaskResponse(
      whisperMessage: whisperMessage,
      snackBarMessage: kekstraMessage,
    );
  }

  final List<DateTime> _recentCompletions = [];

  Future<String?> completeTask(Id id) async {
    String? countStr = await _storage.read(key: 'totalCompleted');
    int count = (int.tryParse(countStr ?? '0') ?? 0) + 1;
    await _storage.write(key: 'totalCompleted', value: count.toString());
    if (count == 1000) {
      return 'ENDGAME_SIGNAL';
    }

    final now = DateTime.now();
    _recentCompletions.add(now);
    _recentCompletions.removeWhere((time) => now.difference(time).inSeconds > 3);

    if (_recentCompletions.length == 3) {
      // KART 3: Toksik Pozitiflik (%0.2)
      if (Random().nextDouble() < 0.002) {
        _recentCompletions.clear();
        await _loadTasks();
        return 'EGG_TOXIC_POSITIVITY';
      }
    }

    if (_recentCompletions.length >= 4) {
      _recentCompletions.clear();
      await _loadTasks();
      return AppTexts.kekstraSpeedrun;
    }

    TaskModel? taskToComplete;
    if (kIsWeb) {
      taskToComplete = DatabaseService.webMockTasks.firstWhere((t) => t.id == id);
    } else {
      taskToComplete = await DatabaseService.isar!.taskModels.get(id);
    }

    if (taskToComplete != null) {
      final diff = now.difference(taskToComplete.createdAt).inSeconds;
      final lowerText = taskToComplete.text.toLowerCase();

      // Kekstra 26: Bounty Hunter
      if (diff < 2) {
        await _deleteTaskHard(id);
        await _loadTasks();
        return AppTexts.kekstraBountyHunter;
      }

      // Kekstra 22: Teleport Cheat
      if (diff < 15 && (lowerText.contains('temizle') || lowerText.contains('tez') || lowerText.contains('topla') || lowerText.contains('bütün'))) {
        await _loadTasks();
        return AppTexts.kekstraTeleport;
      }

      // Kekstra 21: Selective Laziness
      if (diff < 3600) {
        final oldTasks = state.where((t) => now.difference(t.createdAt).inDays > 3 && t.id != id);
        if (oldTasks.isNotEmpty) {
          await _deleteTaskHard(id);
          await _loadTasks();
          return AppTexts.kekstraSelectiveLaziness;
        }
      }

      if (kIsWeb) {
        taskToComplete.isDeleted = true;
        taskToComplete.deletedAt = now;
        taskToComplete.completedAt = now;
      } else {
        await DatabaseService.isar!.writeTxn(() async {
          taskToComplete!.isDeleted = true;
          taskToComplete.deletedAt = now;
          taskToComplete.completedAt = now;
          await DatabaseService.isar!.taskModels.put(taskToComplete);
        });
      }
    }

    ref.read(tripProvider.notifier).decreaseScore(5);
    ref.read(statsProvider.notifier).incrementCompleted();
    await _loadTasks();
    return null;
  }

  Future<void> undoCompleteTask(Id id, {String? newText}) async {
    TaskModel? taskToComplete;
    if (kIsWeb) {
      taskToComplete = DatabaseService.webMockTasks.firstWhere((t) => t.id == id);
    } else {
      taskToComplete = await DatabaseService.isar!.taskModels.get(id);
    }

    if (taskToComplete != null) {
      if (kIsWeb) {
        taskToComplete.isDeleted = false;
        taskToComplete.deletedAt = null;
        taskToComplete.completedAt = null;
        if (newText != null) {
          taskToComplete.text = newText;
        }
      } else {
        await DatabaseService.isar!.writeTxn(() async {
          taskToComplete!.isDeleted = false;
          taskToComplete.deletedAt = null;
          taskToComplete.completedAt = null;
          if (newText != null) {
            taskToComplete.text = newText;
          }
          await DatabaseService.isar!.taskModels.put(taskToComplete);
        });
      }
      ref.read(tripProvider.notifier).increaseScore(20);
      await _loadTasks();
    }
  }

  Future<String?> postponeTask(Id id) async {
    String? message;
    if (kIsWeb) {
      final idx = DatabaseService.webMockTasks.indexWhere((t) => t.id == id);
      if (idx != -1) {
        final task = DatabaseService.webMockTasks[idx];
        task.isPostponed = true;
        task.postponedAt = DateTime.now();
        task.snoozeCount++;
        if (task.snoozeCount == 5) {
          task.text = "hayal: ${task.text.replaceFirst('[BUGÜN YAPACAKTIN] ', '')}";
          message = AppTexts.kekstraZombie;
        }
      }
    } else {
      await DatabaseService.isar!.writeTxn(() async {
        final task = await DatabaseService.isar!.taskModels.get(id);
        if (task != null) {
          task.isPostponed = true;
          task.postponedAt = DateTime.now();
          task.snoozeCount++;
          if (task.snoozeCount == 5) {
            task.text = "hayal: ${task.text.replaceFirst('[BUGÜN YAPACAKTIN] ', '')}";
            message = AppTexts.kekstraZombie;
          }
          await DatabaseService.isar!.taskModels.put(task);
        }
      });
    }
    ref.read(tripProvider.notifier).increaseScore(15);
    ref.read(statsProvider.notifier).incrementPostponed();
    await _loadTasks();
    return message;
  }

  Future<String?> reorderTasks(int oldIndex, int newIndex) async {
    String? message;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);

    // Kekstra 27: Ostrich Syndrome
    if (newIndex == state.length - 1) {
      final lower = item.text.toLowerCase();
      if (lower.contains('vergi') || lower.contains('fatura') || lower.contains('borç') || lower.contains('kira')) {
        state.remove(item);
        state.insert(0, item);
        message = AppTexts.kekstraOstrich;
      }
    }

    if (kIsWeb) {
      for (int i = 0; i < state.length; i++) {
        state[i].orderIndex = i;
      }
    } else {
      await DatabaseService.isar!.writeTxn(() async {
        for (int i = 0; i < state.length; i++) {
          final t = state[i];
          t.orderIndex = i;
          await DatabaseService.isar!.taskModels.put(t);
        }
      });
    }
    state = [...state];
    return message;
  }

  Future<void> _deleteTaskHard(Id id) async {
    if (kIsWeb) {
      DatabaseService.webMockTasks.removeWhere((t) => t.id == id);
    } else {
      await DatabaseService.isar!.writeTxn(() async {
        await DatabaseService.isar!.taskModels.delete(id);
      });
    }
  }

  Future<String?> updateTask(Id id, String newText) async {
    TaskModel? task;
    if (kIsWeb) {
      task = DatabaseService.webMockTasks.firstWhere((t) => t.id == id);
    } else {
      task = await DatabaseService.isar!.taskModels.get(id);
    }
    
    if (task != null) {
      final oldText = task.text;
      final diffDays = DateTime.now().difference(task.createdAt).inDays;
      String? message;

      if (diffDays >= 2 && (oldText.length - newText.length).abs() <= 2 && oldText != newText) {
        message = AppTexts.kekstraTdk;
      }

      if (kIsWeb) {
        task.text = newText;
      } else {
        await DatabaseService.isar!.writeTxn(() async {
          task!.text = newText;
          await DatabaseService.isar!.taskModels.put(task);
        });
      }
      await _loadTasks();
      return message;
    }
    return null;
  }

  Future<void> clearAllTasks() async {
    if (kIsWeb) {
      DatabaseService.webMockTasks.clear();
    } else {
      await DatabaseService.isar!.writeTxn(() async {
        await DatabaseService.isar!.taskModels.clear();
      });
    }
    _loadTasks();
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier(ref);
});
