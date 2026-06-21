import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

abstract class WorkspaceDetailRepository {
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchProject({
    required String workspaceId,
  });
  Future<void> initProjectRealtime({required String workspaceId});
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchMember({
    required String workspaceId,
  });
  Future<void> initMemberRealtime({required String workspaceId});
  Stream<Set<ModelUser>> watchUser();

  void disposeWorkspaceRealtime();

  Future<CollectorMessage?> updateProject({
    required ModelProjectMerge original,
    required ModelProjectMerge edited,
    required Set<(String userId, String role)> contributor,
  });

  Future<CollectorMessage?> createProject({
    required String name,
    required DateTime start,
    required DateTime end,
    required Set<(String userId, String role)> contributor,
    required String type,
    required String workspaceId,
  });

  Future<CollectorMessage?> deleteProject(String idProject);
}
