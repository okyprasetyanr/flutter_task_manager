import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_labels.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class TaskLabelLocalSource {
  final LocalDatabase localDatabase;
  final SyncTable syncTable;
  final ResponseWrapperLocal responseWrapper;

  TaskLabelLocalSource({
    required this.localDatabase,
    required this.syncTable,
    required this.responseWrapper,
  });

  Future<void> syncTaskLabel({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelTaskLabels, TaskLabel>(
      init: init,
      remoteModels: remoteResults
          .map((e) => ModelTaskLabels.fromJson(e))
          .toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.taskLabels,
      idColumn: localDatabase.taskLabels.id,
      modelData: (ModelTaskLabels model) => TaskLabel(
        id: model.id,
        taskId: model.taskId,
        labelId: model.labelId,
        projectId: model.projectId,
      ),
    );
  }

  Future<void> deleteTaskLabel(String id) async {
    try {
      await syncTable.deleteData(
        id: id,
        tableName: localDatabase.taskLabels,
        idColumn: localDatabase.taskLabels.id,
      );
      devLog("Log TaskLabelLocalSource: delete: id: $id");
    } catch (e) {
      devLog("Log TaskLabelLocalSource: delete: error: ${e.toString()}");
    }
  }

  Stream<Map<String, dynamic>> watchTaskLabel({required String projectId}) {
    final query = localDatabase.select(localDatabase.taskLabels)
      ..where((tbl) => tbl.projectId.equals(projectId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<TaskLabel> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }
}
