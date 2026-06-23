import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';

abstract class NotificationRepository {
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchNotification();

  Future<void> initNotificationRealtime();

  void disposeRealtime();

  Future<CollectorMessage?> updateIsRead({required String notificationId});
}
