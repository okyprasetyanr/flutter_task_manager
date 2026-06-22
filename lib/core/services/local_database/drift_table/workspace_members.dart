import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/companies.dart';
import 'package:task_manager/core/services/local_database/drift_table/users.dart';
import 'package:task_manager/core/services/local_database/drift_table/workspaces.dart';

class WorkspaceMembers extends Table {
  TextColumn get workspaceId =>
      text().references(Workspaces, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId =>
      text().references(UserMembers, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text()();
  TextColumn get companyId =>
      text().references(Companies, #id, onDelete: KeyAction.cascade)();
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id};
}
