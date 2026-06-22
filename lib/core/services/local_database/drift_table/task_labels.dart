import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/labels.dart';
import 'package:task_manager/core/services/local_database/drift_table/tasks.dart';
import 'package:task_manager/core/services/local_database/local_database.dart';

class TaskLabels extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get labelId =>
      text().references(Labels, #id, onDelete: KeyAction.setNull)();
  TextColumn get projectId =>
      text().references(Project, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}
