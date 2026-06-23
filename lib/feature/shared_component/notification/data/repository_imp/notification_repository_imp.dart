import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/notification/domain/enum/enum.dart';
import 'package:task_manager/feature/shared_component/notification/domain/repository/notification_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/notification/domain/model/model_notification.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class NotificationRepositoryImp implements NotificationRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;

  NotificationRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });

  RealtimeChannel? notificationChannel;

  @override
  Future<void> initNotificationRealtime() async {
    final userId = userSession.getUserId();
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .notificationRemote
          .getAllNotification(userId: userId);
      devLog("Log NotificationRepositoryImp: init: $rawRemoteData");
      await local.notificationLocal.syncNotification(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log NotificationRepositoryImp: error: $e");
    }

    if (notificationChannel != null) {
      remote.notificationRemote.removeNotificationChannel(notificationChannel!);
    }
    notificationChannel = remote.notificationRemote.buildNotificationChannel(
      userId,
    );

    notificationChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.notifications.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumNotification.userId.value,
            value: userId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
              } else {
                final data = payload.newRecord;
                await local.notificationLocal.syncNotification(
                  remoteResults: [data],
                );
              }
            } catch (e) {
              devLog("Log NotificationRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log NotificationRepositoryImp: error Supabase: $error");
          }
        });
  }

  @override
  Future<CollectorMessage?> updateIsRead({
    required String notificationId,
  }) async {
    final data = await helper.collectDataRemote(
      remoteFunc: () => remote.notificationRemote.updateNotification(
        data: ModelNotification.updateIsRead(notificationId: notificationId),
      ),
      localFunc: ({required dataToCache}) async => {},
    );
    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }

  @override
  void disposeRealtime() {
    if (notificationChannel != null) {
      remote.notificationRemote.removeNotificationChannel(notificationChannel!);
      notificationChannel = null;
    }
  }

  @override
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchNotification() {
    return local.notificationLocal
        .watchNotification(userId: userSession.getUserId())
        .map((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          return (data, messageCollector.getMessage(data));
        });
  }
}
