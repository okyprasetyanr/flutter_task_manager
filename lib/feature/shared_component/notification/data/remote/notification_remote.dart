import 'package:task_manager/core/services/remote_service/remote_service.dart';

class NotificationRemote {
  final RemoteService apiServices;

  NotificationRemote({required this.apiServices});

  Future<Map<String, dynamic>> getNotification({required String userId}) async {
    final data = await apiServices.getNotification(userId);
    return data;
  }
}
