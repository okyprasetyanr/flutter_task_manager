// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/cache/notification_cache.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/stream_manager/stream_manager.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/enum/enum.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/repository/not_log_repository.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar_root.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class NotLogRepositoryImp
    with StreamSubscriptionManager
    implements NotLogRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserRepository userRepo;
  final NotificationCache notificationCache;

  NotLogRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userRepo,
    required this.notificationCache,
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
      notificationChannel = null;
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
  Future<void> watchNotification() async {
    await initNotificationRealtime();

    addStreamSubscription(
      EnumTable.notifications,
      local.notificationLocal
          .watchNotification(userId: userSession.getUserId())
          .listen((event) {
            final data = helper.collectDataLocal(fetchResult: event);

            if (data.containsKey(EnumFetchApiStatus.success)) {
              notificationCache.setNotification(
                (data[EnumFetchApiStatus.success] as List)
                    .map((e) => ModelNotification.fromDrift(e))
                    .toSet(),
              );
            } else {
              customRootSnackBar(messageCollector.getMessage(data));
            }
          }),
    );
  }

  @override
  Stream<Set<ModelNotification>> getNotification() {
    devLog("Log NotificationRepository: getNotification: check");
    return notificationCache.stream;
  }

  @override
  Future<void> disposeRealtime() async {
    clearStreamSubscriptions();
    if (notificationChannel != null) {
      remote.notificationRemote.removeNotificationChannel(notificationChannel!);
      notificationChannel = null;
    }
    notificationCache.clear();
  }

  @override
  Future<void> logout() async {
    await disposeRealtime();
    await userRepo.disposeUserRealtime();
    await remote.loginRemote.logout();
    await userSession.clear();
  }
}
