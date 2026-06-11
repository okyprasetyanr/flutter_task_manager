// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_task.dart';

class TaskDetailEvent {}

class TaskDetailEventGetData extends TaskDetailEvent {
  final ModelTask? dataTask;

  TaskDetailEventGetData({required this.dataTask});
}

class TaskDetailEventChangeStatus extends TaskDetailEvent {
  final EnumStatusState status;
  TaskDetailEventChangeStatus({required this.status});
}
