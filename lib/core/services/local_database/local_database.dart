import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:task_manager/core/services/local_database/drift_table/activities.dart';
import 'package:task_manager/core/services/local_database/drift_table/comments.dart';
import 'package:task_manager/core/services/local_database/drift_table/companies.dart';
import 'package:task_manager/core/services/local_database/drift_table/labels.dart';
import 'package:task_manager/core/services/local_database/drift_table/notifications.dart';
import 'package:task_manager/core/services/local_database/drift_table/project_members.dart';
import 'package:task_manager/core/services/local_database/drift_table/projects.dart';
import 'package:task_manager/core/services/local_database/drift_table/sub_tasks.dart';
import 'package:task_manager/core/services/local_database/drift_table/task_histories.dart';
import 'package:task_manager/core/services/local_database/drift_table/task_labels.dart';
import 'package:task_manager/core/services/local_database/drift_table/tasks.dart';
import 'package:task_manager/core/services/local_database/drift_table/users.dart';
import 'package:task_manager/core/services/local_database/drift_table/workspace_members.dart';
import 'package:task_manager/core/services/local_database/drift_table/workspaces.dart';

part 'local_database.g.dart';

@DriftDatabase(
  tables: [
    Companies,
    Users,
    Projects,
    ProjectMembers,
    Workspaces,
    WorkspaceMembers,
    Labels,
    Activities,
    Comments,
    Notifications,
    SubTasks,
    TaskHistories,
    TaskLabels,
    Tasks,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(p.join(dir.path, 'task_manager.sqlite'));

    return NativeDatabase(file);
  });
}
