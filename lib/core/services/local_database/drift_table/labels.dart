import 'package:drift/drift.dart';

class Labels extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get color => text()();

  @override
  Set<Column> get primaryKey => {id};
}
