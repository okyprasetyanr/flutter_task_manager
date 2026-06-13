import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceDetailRemote {
  final RemoteService apiServices;

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
    devLog(
      "Log WorkspaceDetailRemote: data: ${{
        'status': "success",
        'results': {"workspace_project": workspaceProject['results'], "workspace_member": workspaceMember['results']},
        'message': '',
      }}",
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
