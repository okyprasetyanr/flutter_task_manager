import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/notification/domain/repository/notification_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/notification/domain/model/model_notification.dart';

class NotificationRepositoryImp implements NotificationRepository {
  final RemoteService remote;
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

  @override
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchNotification() {
    return remote.notificationRemote
        .watchNotification(userId: userSession.getUserId())
        .asyncMap((rawMapFromRemote) async {
          final Map<EnumFetchApiStatus, dynamic> data = await helper
              .helperCollectData(
                remoteFunc: () async => rawMapFromRemote,
                localFunc: () async => {},
              );
          final collectorMessage = messageCollector.getMessage(data);
          return (data, collectorMessage);
        });
  }

  @override
  Future<CollectorMessage?> updateIsRead({
    required String notificationId,
  }) async {
    final data = await helper.helperCollectData(
      remoteFunc: () => remote.notificationRemote.updateNotification(
        data: ModelNotification.updateIsRead(notificationId: notificationId),
      ),
      localFunc: () => {},
    );
    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }
}
