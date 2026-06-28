import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';

abstract class NotLogRepository {
  Stream<Set<ModelNotification>> getNotification();

  Future<void> initNotificationRealtime();

  void disposeRealtime();

  Future<CollectorMessage?> updateIsRead({required String notificationId});

  void logout();

  void watchNotification();
}
