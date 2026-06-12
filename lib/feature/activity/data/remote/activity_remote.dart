import 'package:task_manager/core/services/api_service/api_services.dart';

class ActivityRemote {
  final ApiServices apiServices;

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
