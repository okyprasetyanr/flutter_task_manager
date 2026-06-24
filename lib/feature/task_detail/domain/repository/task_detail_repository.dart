import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';

abstract class TaskDetailRepository {
  Stream<TaskDetailStateLoaded> watchDashboard({
    required ModelTaskMerge task,
    required Set<ModelLabel> label,
  });
  Future<void> initCommentRealtime({required String taskId});

  Future<CollectorMessage?> createComment({
    required String content,
    required String taskId,
  });

  Future<CollectorMessage?> deleteComment({required String commentId});

  Future<CollectorMessage?> createSubTask({
    required String title,
    required String taskId,
    required String projectId,
  });

  Future<CollectorMessage?> deleteSubTask({required String subtaskId});

  Future<CollectorMessage?> updateSubtask({
    required ModelSubTask original,
    required ModelSubTask edited,
  });

  void disposeRealtime();
}
