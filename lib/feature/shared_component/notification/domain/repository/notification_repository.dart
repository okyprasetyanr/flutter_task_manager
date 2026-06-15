import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

abstract class NotificationRepository {
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchNotification();

  Future<CollectorMessage?> updateIsRead({required String notificationId});
}
