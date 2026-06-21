import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/companies.dart';

class Workspaces extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get ownerId =>
      text().references(Companies, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get companyId =>
      text().references(Companies, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {id};
}
