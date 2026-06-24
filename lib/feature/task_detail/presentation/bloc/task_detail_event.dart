// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

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

class TaskDetailEventCreateComment extends TaskDetailEvent {
  final String content;

  TaskDetailEventCreateComment({required this.content});
}

class TaskDetailEventCreateSubtask extends TaskDetailEvent {
  final String title;
  final bool isDone;

  TaskDetailEventCreateSubtask({required this.title, required this.isDone});
}

class TaskDetailEventDeleteComment extends TaskDetailEvent {
  final String commentId;

  TaskDetailEventDeleteComment({required this.commentId});
}

class TaskDetailEventDeleteSubtask extends TaskDetailEvent {}

class TaskDetailEventUpdateSubtask extends TaskDetailEvent {
  final String title;
  final bool isDone;

  TaskDetailEventUpdateSubtask({required this.title, required this.isDone});
}

class TaskDetailEventSelectedSubtask extends TaskDetailEvent {
  final ModelSubTask data;

  TaskDetailEventSelectedSubtask({required this.data});
}

class TaskDetailEventResetSelected extends TaskDetailEvent {}
