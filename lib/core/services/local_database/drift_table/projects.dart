import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/users.dart';
import 'package:task_manager/core/services/local_database/drift_table/workspaces.dart';

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  TextColumn get createdBy =>
      text().references(UserMembers, #id, onDelete: KeyAction.setNull)();
  IntColumn get totalContribut => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  TextColumn get workspaceId =>
      text().references(Workspaces, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}
