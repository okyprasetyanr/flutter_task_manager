import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';

class SubtaskLocalSource {
  final LocalDatabase localDatabase;
  final SyncTable syncTable;
  final ResponseWrapperLocal responseWrapper;

  SubtaskLocalSource({
    required this.localDatabase,
    required this.syncTable,
    required this.responseWrapper,
  });

  Future<void> syncSubTask({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelSubTask, SubTask>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelSubTask.fromJson(e)).toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.subTasks,
      idColumn: localDatabase.subTasks.id,
      modelData: (ModelSubTask model) => SubTask(
        id: model.id,
        taskId: model.taskId,
        title: model.title,
        isDone: model.isDone,
        projectId: model.projectId,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchSubTask({required String projectId}) {
    final query = localDatabase.select(localDatabase.subTasks)
      ..where((tbl) => tbl.projectId.equals(projectId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<SubTask> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteSubTask(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.subTasks,
      idColumn: localDatabase.subTasks.id,
    );
  }
}
