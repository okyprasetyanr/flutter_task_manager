import 'package:drift/drift.dart';
import 'package:task_manager/shared/drift_table/tasks.dart';
import 'package:task_manager/shared/drift_table/users.dart';

class TaskHistories extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.setNull)();
  TextColumn get field => text()();
  TextColumn get oldValue => text()();
  TextColumn get newValue => text()();
  TextColumn get changedBy =>
      text().references(Users, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get changedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
