import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/users.dart';
import 'package:task_manager/core/services/local_database/drift_table/workspaces.dart';

class ProjectMembers extends Table {
  TextColumn get projectId => text()();
  TextColumn get workspaceId =>
      text().references(Workspaces, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId =>
      text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text()();
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id};
}
