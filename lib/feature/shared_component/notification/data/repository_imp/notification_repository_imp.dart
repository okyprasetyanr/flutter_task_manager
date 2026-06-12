import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/notification/data/local/notification_local.dart';
import 'package:task_manager/feature/shared_component/notification/data/remote/notification_remote.dart';
import 'package:task_manager/feature/shared_component/notification/domain/repository/notification_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';

class NotificationRepositoryImp implements NotificationRepository {
  final NotificationRemote remote;
  final NotificationLocal local;
  final UserSession userSession;
  final HelperCollectData helper;
  final ModelMessageCollector messageCollector;

  NotificationRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });

  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getNotification() async {
    final data = await helper.helperCollectData(
      remoteFunc: () async =>
          await remote.getNotification(userId: userSession.getUserId()),
      localFunc: () async => {},
    );

    return (data, messageCollector.getMessage(data));
  }
}
