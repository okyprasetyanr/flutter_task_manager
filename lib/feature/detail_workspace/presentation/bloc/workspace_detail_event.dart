import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

class WorkspaceDetailEvent {}

class WorkspaceDetailEventGetData extends WorkspaceDetailEvent {
  final ModelWorkspace data;

  WorkspaceDetailEventGetData({required this.data});
}

class WorkspaceDetailEventChangeStatus extends WorkspaceDetailEvent {
  final EnumStatusState status;

  WorkspaceDetailEventChangeStatus({required this.status});
}
