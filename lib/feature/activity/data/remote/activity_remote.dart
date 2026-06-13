import 'package:task_manager/core/services/remote_service/remote_service.dart';

class ActivityRemote {
  final RemoteService apiServices;

  ActivityRemote({required this.apiServices});
  Future<Map<String, dynamic>> getActivity({
    required String workspaceId,
    required String companyId,
  }) async {
    return await apiServices.getActivities(
      companyId: companyId,
      workspaceId: workspaceId,
    );
  }
}
