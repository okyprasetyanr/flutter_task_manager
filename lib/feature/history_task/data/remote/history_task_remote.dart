import 'package:task_manager/core/services/remote_service/remote_service.dart';

class HistoryTaskRemote {
  final RemoteService apiServices;

  HistoryTaskRemote({required this.apiServices});

  Future<Map<String, dynamic>> getHistoryTask({
    required String companyId,
    required String workspaceId,
  }) async {
    return apiServices.getTaskHistory(workspaceId: workspaceId);
  }
}
