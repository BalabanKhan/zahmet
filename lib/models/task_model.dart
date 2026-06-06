import 'package:isar/isar.dart';

part 'task_model.g.dart';

@collection
@Name('Task')
class TaskModel {
  Id id = Isar.autoIncrement;

  late String text;
  
  bool isPostponed = false;
  bool isCompleted = false;
  bool isDeleted = false;
  DateTime? deletedAt;

  DateTime createdAt = DateTime.now();
  DateTime? completedAt;
  DateTime? postponedAt;
  int snoozeCount = 0;
  int orderIndex = 0;
}
