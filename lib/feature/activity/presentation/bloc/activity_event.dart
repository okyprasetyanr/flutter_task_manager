import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

class ActivityEvent {}

class ActivityEventGetData extends ActivityEvent {
  final ModelWorkspace? data;

  ActivityEventGetData({required this.data});
}

class ActivityEventChangeStatus extends ActivityEvent {
  final EnumStatusState status;

  ActivityEventChangeStatus({required this.status});
}
