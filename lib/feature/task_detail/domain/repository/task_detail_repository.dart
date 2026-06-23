import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/model/model_label.dart';

abstract class TaskDetailRepository {
  Stream<TaskDetailStateLoaded> watchDashboard({
    required ModelTaskMerge task,
    required Set<ModelLabel> label,
  });
  Future<void> initCommentRealtime({required String taskId});
  void disposeRealtime();
}
