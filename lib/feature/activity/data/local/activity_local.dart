import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/activity/domain/enum/enum.dart';
import 'package:task_manager/feature/activity/domain/model/model_activity.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';

class ActivityLocal {
  final LocalDatabase localDatabase;
  final ResponseWrapperLocal responseWrapper;
  final SyncTable syncTable;

  ActivityLocal({
    required this.localDatabase,
    required this.responseWrapper,
    required this.syncTable,
  });

  Future<void> syncActivity({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelActivity, Activity>(
      init: init,
      remoteModels: remoteResults
          .map((e) => ModelActivity.fromJson(e))
          .toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.activities,
      idColumn: localDatabase.activities.id,
      modelData: (ModelActivity model) => Activity(
        id: model.id,
        taskId: model.taskId,
        userId: model.userId,
        action: model.action.text,
        oldValue: model.oldValue,
        newValue: model.newValue,
        createdAt: model.createdAt,
        workspaceId: model.workspaceId,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchActivity({required String workspaceId}) {
    final query = localDatabase.select(localDatabase.activities)
      ..where((tbl) => tbl.workspaceId.equals(workspaceId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<Activity> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }
}
