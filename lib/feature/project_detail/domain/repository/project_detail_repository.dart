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
  void disposeRealtime();
}
