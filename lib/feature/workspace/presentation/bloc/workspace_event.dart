// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

class WorkspaceEvent {}

class WorkspaceEventGetData extends WorkspaceEvent {}

class WorkspaceEventChangeStatus extends WorkspaceEvent {
  final EnumStatusState status;
  WorkspaceEventChangeStatus({required this.status});
}

class WorkspaceEventCreateWorkspace extends WorkspaceEvent {
  final ModelWorkspace data;
  WorkspaceEventCreateWorkspace({required this.data});
}

class WorkspaceEventUpdateWorkspace extends WorkspaceEvent {
  final ModelWorkspace data;
  WorkspaceEventUpdateWorkspace({required this.data});
}

class WorkspaceEventDeleteWorkspace extends WorkspaceEvent {
  final String idWorkspace;

  WorkspaceEventDeleteWorkspace({required this.idWorkspace});
}

class WorkspaceEventWatchWorkspace extends WorkspaceEvent {}

class WorkspaceEventSelectedData extends WorkspaceEvent {
  final ModelWorkspace data;
  WorkspaceEventSelectedData({required this.data});
}
