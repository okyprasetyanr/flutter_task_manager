import 'package:task_manager/core/services/api_service/api_services.dart';

class NotificationRemote {
  final ApiServices apiServices;

  NotificationRemote({required this.apiServices});

  Future<Map<String, dynamic>> getNotification({required String userId}) async {
    final data = await apiServices.getNotification(userId);
    return data;
  }
}
