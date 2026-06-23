// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_label.dart';

class TaskDetailEvent {}

class TaskDetailEventWatchDashboard extends TaskDetailEvent {
  final ModelTaskMerge? dataTask;
  final Set<ModelLabel>? dataLabel;

  TaskDetailEventWatchDashboard({this.dataTask, this.dataLabel});
}

class TaskDetailEventChangeStatus extends TaskDetailEvent {
  final EnumStatusState status;
  TaskDetailEventChangeStatus({required this.status});
}
