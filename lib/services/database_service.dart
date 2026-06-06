import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

class DatabaseService {
  static Isar? isar;
  static List<TaskModel> webMockTasks = [];

  static Future<void> initialize() async {
    if (kIsWeb) {
      webMockTasks = [
        TaskModel()
          ..id = 1
          ..text = "bugün de yataktan çıkmamak"
          ..createdAt = DateTime.now().subtract(const Duration(hours: 4))
          ..orderIndex = 0,
        TaskModel()
          ..id = 2
          ..text = "spora başlama yalanı"
          ..createdAt = DateTime.now().subtract(const Duration(hours: 3))
          ..orderIndex = 1,
        TaskModel()
          ..id = 3
          ..text = "[BUGÜN YAPACAKTIN] faturaları öde"
          ..createdAt = DateTime.now().subtract(const Duration(days: 1))
          ..orderIndex = 2
          ..isPostponed = false,
        TaskModel()
          ..id = 4
          ..text = "kalan 26 görevi yarına ertelemek"
          ..createdAt = DateTime.now().subtract(const Duration(hours: 1))
          ..orderIndex = 3,
      ];
      return;
    }
    
    final dir = await getApplicationDocumentsDirectory();
    
    isar = await Isar.open(
      [TaskModelSchema],
      directory: dir.path,
    );
  }
}
