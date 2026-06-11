import 'package:task_manager/core/services/api_service/api_services.dart';

class HistoryTaskRemote {
  final ApiServices apiServices;

  HistoryTaskRemote({required this.apiServices});

  Future<Map<String, dynamic>> getHistoryTask({
    required String companyId,
    required String workspaceId,
  }) async {
    return apiServices.getTaskHistory(workspaceId: workspaceId);
  }
}
