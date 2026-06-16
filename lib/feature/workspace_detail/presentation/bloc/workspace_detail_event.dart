import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

class WorkspaceDetailEvent {}

class WorkspaceDetailEventWatch extends WorkspaceDetailEvent {
  final ModelWorkspace? data;

  WorkspaceDetailEventWatch({required this.data});
}

class WorkspaceDetailEventChangeStatus extends WorkspaceDetailEvent {
  final EnumStatusState status;

  WorkspaceDetailEventChangeStatus({required this.status});
}

class WorkspaceDetailEventWatchMember extends WorkspaceDetailEvent {}
