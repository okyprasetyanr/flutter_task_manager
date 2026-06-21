import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/projects.dart';
import 'package:task_manager/core/services/local_database/drift_table/users.dart';

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get sprintId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get status => text()();
  TextColumn get priority => text()();
  IntColumn get storyPoint => integer()();
  TextColumn get reporterId =>
      text().references(Users, #id, onDelete: KeyAction.setNull)();
  TextColumn get assigneeId =>
      text().references(Users, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
