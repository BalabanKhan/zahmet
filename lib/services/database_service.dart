import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

class DatabaseService {
  static Isar? isar;
  static List<TaskModel> webMockTasks = [];

  static Future<void> initialize() async {
    if (kIsWeb) return; // Isar 3.1.0 doesn't support Web
    
    final dir = await getApplicationDocumentsDirectory();
    
    isar = await Isar.open(
      [TaskModelSchema],
      directory: dir.path,
    );
  }
}
