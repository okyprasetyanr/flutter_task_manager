import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

abstract class WorkspaceRepository {
  Stream<WorkspaceStateLoaded> watchDashboard();

  Future<void> initWorkspaceRealtime();

  Future<void> initMemberRealtime();

  void disposeRealtime();

  String getCompanyName();

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
