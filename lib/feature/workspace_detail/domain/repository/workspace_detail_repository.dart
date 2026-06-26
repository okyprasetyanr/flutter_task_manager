import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/enum.dart';

abstract class WorkspaceDetailRepository {
  Stream<WorkspaceDetailStateLoaded> watchDashboard({
    required ModelWorkspaceMerge workspace,
  });

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
    required String type,
    required String workspaceId,
  });

  Future<CollectorMessage?> deleteProject(String idProject);
}
