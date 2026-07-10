import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/enum.dart';

abstract class WorkspaceDetailRepository {
  Stream<
    (
      Set<ModelUser>,
      Set<ModelProjectMerge>,
      Set<String>,
      CollectorMessage,
      ModelUser,
    )
  >
  watchDashboard({required ModelWorkspaceMerge workspace});

  Future<void> initProjectRealtime({required String workspaceId});

  Future<void> initMemberRealtime({required String workspaceId});

  void disposeRealtime();

  Future<CollectorMessage?> updateProject({
    required ModelProjectMerge original,
    required ModelProjectMerge edited,
    required Set<(String userId, EnumProjectRole role)> contributor,
  });

  Future<CollectorMessage?> createProject({
    required String name,
    required DateTime start,
    required DateTime end,
    required Set<(String userId, EnumProjectRole role)> contributor,
    required EnumProjectType type,
    required String workspaceId,
  });

  Future<CollectorMessage?> deleteProject(String idProject);
}
