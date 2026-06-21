import 'package:drift/drift.dart';
import 'package:task_manager/core/services/local_database/drift_table/users.dart';

class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get body => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
