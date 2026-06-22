import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/tasks.dart';
import 'package:task_manager/core/services/local_database/local_database.dart';

class SubTasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  TextColumn get projectId =>
      text().references(Project, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}
