import 'package:task_manager/core/services/api_service/api_services.dart';

class WorkspaceDetailRemote {
  final ApiServices apiServices;

  WorkspaceDetailRemote({required this.apiServices});

  Future<Map<String, dynamic>> getWorkspaceDetail({
    required String workspaceId,
    required String companyId,
  }) async {
    final workspaceMember = await apiServices.getWorkspaceMember(
      workspaceId,
      companyId,
    );
    final workspaceProject = await apiServices.getProject(
      workspaceId,
      companyId,
    );
    return {
      'status': "success",
      'results': {
        "workspace_project": workspaceProject['results'],
        "workspace_member": workspaceMember['results'],
      },
      'message': '',
    };
  }

  Future<Map<String, dynamic>> getUser({required String companyId}) {
    return apiServices.getUser(companyId);
  }
}
