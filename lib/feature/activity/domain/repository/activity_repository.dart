import 'package:task_manager/feature/activity/presentation/bloc/activity_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';

abstract class ActivityRepository {
  Stream<ActivityStateLoaded> watchDashboard({
    required ModelWorkspaceMerge workspace,
  });

  void disposeActivityRealtime();

  Future<void> initActivityRealTime({required String workspaceId});
}
