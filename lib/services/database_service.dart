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
    
    final dir = await getApplicationDocumentsDirectory();
    
    try {
      isar = await Isar.open(
        [TaskModelSchema],
        directory: dir.path,
      );
    } catch (e) {
      // If there is a schema mismatch (e.g. Collection id is invalid), Isar will throw.
      // We can delete the old database and try again.
      debugPrint('[ZAHMET_LOG] Isar open failed, attempting to clear database: $e');
      try {
        final coreFile = File('${dir.path}/default.isar');
        if (coreFile.existsSync()) coreFile.deleteSync();
        final lockFile = File('${dir.path}/default.isar.lock');
        if (lockFile.existsSync()) lockFile.deleteSync();
      } catch (_) {}
      
      try {
        isar = await Isar.open(
          [TaskModelSchema],
          directory: dir.path,
        );
      } catch (e2) {
        debugPrint('[ZAHMET_LOG] Second attempt to open Isar failed: $e2');
        rethrow;
      }
    }
  }
}
