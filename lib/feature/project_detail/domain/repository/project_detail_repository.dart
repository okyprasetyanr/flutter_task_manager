import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';

abstract class ProjectDetailRepository {
  Stream<ProjectDetailStateLoaded> watchDashboard({
    required ModelProjectMerge project,
  });
  Future<void> initTaskRealtime({required String projectId});
  Future<void> initTaskLabelRealtime({required String projectId});
  Future<void> initSubTaskRealtime({required String projectId});
  Future<void> initLabelRealtime();
  Future<CollectorMessage?> deleteTask({required String taskId});
  Future<CollectorMessage?> createTask({
    required String assigneeId,
    required String description,
    required DateTime startDate,
    required DateTime dueDate,
    required int storyPoint,
    required EnumTaskStatus status,
    required EnumTaskPriority priority,
    required String projectId,
    required String title,
    required Set<ModelLabel> taskLabel,
  });
  Future<CollectorMessage?> updateTask({
    required ModelTaskMerge original,
    required ModelTaskMerge edited,
  });
  void disposeRealtime();
}
