import 'package:drift/drift.dart';
import 'package:task_manager/shared/drift_table/tasks.dart';

class SubTasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
