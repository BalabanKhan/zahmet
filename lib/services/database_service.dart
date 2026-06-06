import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

class DatabaseService {
  static Isar? isar;
  static List<TaskModel> webMockTasks = [];

  static Future<void> initialize() async {
    if (kIsWeb) return; // Isar 3.1.0 doesn't support Web
    
    if (Isar.getInstance() != null) {
      isar = Isar.getInstance();
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    
    try {
      isar = await Isar.open(
        [TaskModelSchema],
        directory: dir.path,
      );
    } catch (e) {
      if (e.toString().contains('already been opened')) {
        isar = Isar.getInstance();
        return;
      }

      debugPrint('[ZAHMET_LOG] Isar open failed, attempting to clear database: $e');
      
      final existingInstance = Isar.getInstance();
      if (existingInstance != null) {
        try { await existingInstance.close(); } catch (_) {}
      }

      try {
        final d = Directory(dir.path);
        if (d.existsSync()) {
          for (var f in d.listSync()) {
            if (f.path.endsWith('.isar') || f.path.endsWith('.isar.lock')) {
               try { f.deleteSync(); } catch (_) {}
            }
          }
        }
      } catch (_) {}
      
      try {
        isar = await Isar.open(
          [TaskModelSchema],
          directory: dir.path,
        );
      } catch (e2) {
        debugPrint('[ZAHMET_LOG] Second attempt to open Isar failed: $e2');
        // Ultimate fallback: If the file is locked by the OS and cannot be deleted,
        // we use a completely new database name to bypass the corrupted locked file.
        isar = await Isar.open(
          [TaskModelSchema],
          directory: dir.path,
          name: 'zahmet_recovery',
        );
      }
    }
  }
}
