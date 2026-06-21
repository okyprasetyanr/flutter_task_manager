import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/labels.dart';
import 'package:task_manager/core/services/local_database/drift_table/tasks.dart';

class TaskLabels extends Table {
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get labelId =>
      text().references(Labels, #id, onDelete: KeyAction.setNull)();

  @override
  Set<Column> get primaryKey => {taskId, labelId};
}
