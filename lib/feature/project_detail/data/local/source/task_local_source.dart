import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task.dart';

class TaskLocalSource {
  final LocalDatabase localDatabase;
  final SyncTable syncTable;
  final ResponseWrapperLocal responseWrapper;

  TaskLocalSource({
    required this.localDatabase,
    required this.syncTable,
    required this.responseWrapper,
  });
  Future<void> syncTask({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelTask, Task>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelTask.fromJson(e)).toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.tasks,
      idColumn: localDatabase.tasks.id,
      modelData: (ModelTask model) => Task(
        id: model.id,
        projectId: model.projectId,
        sprintId: model.sprintId ?? "",
        title: model.title,
        description: model.description,
        status: model.status.text,
        priority: model.priority.text,
        storyPoint: model.storyPoint,
        reporterId: model.reporterId,
        assigneeId: model.assigneeId,
        startDate: model.startDate,
        dueDate: model.dueDate,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchTask({required String projectId}) {
    final query = localDatabase.select(localDatabase.tasks)
      ..where((tbl) => tbl.projectId.equals(projectId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<Task> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteTask(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.tasks,
      idColumn: localDatabase.tasks.id,
    );
  }
}
