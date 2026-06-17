import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

abstract class WorkspaceRepository {
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchWorkspace();
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchWorkspaceMember();

  String getCompanyName();

  Set<ModelUser> getUser();

  Future<CollectorMessage?> createWorkspace({
    required String name,
    required String description,
  });
  Future<CollectorMessage?> updateWorkspace({
    required ModelWorkspace original,
    required ModelWorkspace edited,
  });
  Future<CollectorMessage?> deleteWorkspace({required String workspaceId});
}
