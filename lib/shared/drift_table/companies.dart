import 'package:drift/drift.dart';

class Companies extends Table {
  TextColumn get id => text()();
  TextColumn get companyName => text()();
  DateTimeColumn get companyJoin => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
