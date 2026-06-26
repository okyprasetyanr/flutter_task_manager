// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class ProjectDetailEvent {}

class ProjectDetailEventWatch extends ProjectDetailEvent {
  final ModelProjectMerge? data;

  ProjectDetailEventWatch({this.data});
}

class ProjectDetailEventChangeStatus extends ProjectDetailEvent {
  final EnumStatusState status;

  ProjectDetailEventChangeStatus({required this.status});
}

class ProjectDetailEventSelectedData extends ProjectDetailEvent {
  final ModelTaskMerge selectedDate;

  ProjectDetailEventSelectedData({required this.selectedDate});
}

class ProjectDetailEventResetSelected extends ProjectDetailEvent {}

class ProjectDetailEventCreateTask extends ProjectDetailEvent {
  final String assigneeId;
  final String title;
  final String description;
  final int storyPoint;
  final DateTime start;
  final DateTime due;
  final EnumTaskStatus status;
  final EnumTaskPriority priority;
  final Set<ModelLabel> taskLabel;

  ProjectDetailEventCreateTask({
    required this.taskLabel,
    required this.assigneeId,
    required this.title,
    required this.description,
    required this.storyPoint,
    required this.start,
    required this.due,
    required this.status,
    required this.priority,
  });
}

class ProjectDetailEventUpdateTask extends ProjectDetailEvent {
  final String assigneeId;
  final String description;
  final int storyPoint;
  final DateTime start;
  final DateTime due;
  final EnumTaskStatus status;
  final EnumTaskPriority priority;
  final Set<ModelLabel> taskLabel;

  ProjectDetailEventUpdateTask({
    required this.taskLabel,
    required this.assigneeId,
    required this.description,
    required this.storyPoint,
    required this.start,
    required this.due,
    required this.status,
    required this.priority,
  });
}

class ProjectDetailEventDeleteTask extends ProjectDetailEvent {
  final String taskId;
  ProjectDetailEventDeleteTask({required this.taskId});
}

class ProjectDetailEventSearchLabel extends ProjectDetailEvent {
  final String search;

  ProjectDetailEventSearchLabel({required this.search});
}

class ProjectDetailEventSearchUser extends ProjectDetailEvent {
  final String search;

  ProjectDetailEventSearchUser({required this.search});
}
