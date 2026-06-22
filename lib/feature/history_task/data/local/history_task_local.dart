import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/history_task/domain/model/model_task_history.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';

class HistoryTaskLocal {
  final LocalDatabase localDatabase;
  final ResponseWrapperLocal responseWrapper;
  final SyncTable syncTable;

  HistoryTaskLocal({
    required this.localDatabase,
    required this.responseWrapper,
    required this.syncTable,
  });

  Future<void> syncHistory({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelHistoryTask, TaskHistory>(
      init: init,
      remoteModels: remoteResults
          .map((e) => ModelHistoryTask.fromJson(e))
          .toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.taskHistories,
      idColumn: localDatabase.taskHistories.id,
      modelData: (ModelHistoryTask model) => TaskHistory(
        id: model.id,
        workspaceId: model.workspaceId,
        taskId: model.taskId,
        field: model.field.text,
        oldValue: model.oldValue,
        newValue: model.newValue,
        changedBy: model.changedBy,
        changedAt: model.changedAt,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchHistory({required String workspaceId}) {
    final query = localDatabase.select(localDatabase.taskHistories)
      ..where((tbl) => tbl.workspaceId.equals(workspaceId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<TaskHistory> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }
}
