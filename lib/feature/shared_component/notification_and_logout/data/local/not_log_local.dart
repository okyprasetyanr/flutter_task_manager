import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';

class NotLogLocal {
  ResponseWrapperLocal responseWrapper;
  LocalDatabase localDatabase;
  SyncTable syncTable;
  NotLogLocal({
    required this.responseWrapper,
    required this.localDatabase,
    required this.syncTable,
  });

  Future<void> syncNotification({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelNotification, Notification>(
      init: init,
      remoteModels: remoteResults
          .map((e) => ModelNotification.fromJson(e))
          .toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.notifications,
      idColumn: localDatabase.notifications.id,
      modelData: (ModelNotification model) => Notification(
        id: model.id,
        userId: model.userId,
        title: model.title,
        body: model.body,
        isRead: model.isRead,
        createdAt: model.createdAt,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchNotification({required String userId}) {
    final query = localDatabase.select(localDatabase.notifications)
      ..where((tbl) => tbl.userId.equals(userId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<Notification> rows) {
          return rows.map((row) => row.toJson()).toList();
        });
      },
    );
  }
}
