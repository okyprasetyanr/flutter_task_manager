import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/tasks.dart';
import 'package:task_manager/core/services/local_database/drift_table/users.dart';
import 'package:task_manager/core/services/local_database/drift_table/workspaces.dart';

class Activities extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.setNull)();
  TextColumn get userId =>
      text().references(UserMembers, #id, onDelete: KeyAction.setNull)();
  TextColumn get action => text()();
  TextColumn get oldValue => text()();
  TextColumn get newValue => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get workspaceId =>
      text().references(Workspaces, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}
