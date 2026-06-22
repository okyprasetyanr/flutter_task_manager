import 'package:task_manager/feature/history_task/presentation/bloc/history_task_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';

abstract class HistoryTaskRepository {
  Stream<HistoryTaskStateLoaded> watchDashboard({
    required ModelWorkspaceMerge workspace,
  });
  Future<void> initHistoryRealTime({required String workspaceId});
  void disposeHistoryRealtime();
}
