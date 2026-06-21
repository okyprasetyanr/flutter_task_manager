import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

abstract class WorkspaceRepository {
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchWorkspace();
  // Stream<CollectorMessage> watchMessage();
  Future<void> initWorkspaceRealtime();
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchMember();
  // Stream<CollectorMessage> watchMessageMember();
  Future<void> initMemberRealtime();
  void disposeWorkspaceRealtime();
  String getCompanyName();

  Stream<Set<ModelUser>> getUser();

  Future<CollectorMessage?> createWorkspace({
    required String name,
    required String description,
    required Set<(String userId, EnumWorkspaceRole role)> contributor,
  });
  Future<CollectorMessage?> updateWorkspace({
    required ModelWorkspaceMerge original,
    required ModelWorkspaceMerge edited,
    required Set<(String userId, EnumWorkspaceRole role)> contributor,
  });
  Future<CollectorMessage?> deleteWorkspace({required String workspaceId});
}
