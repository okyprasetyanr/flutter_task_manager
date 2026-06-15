// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

class WorkspaceEvent {}

class WorkspaceEventChangeStatus extends WorkspaceEvent {
  final EnumStatusState status;
  WorkspaceEventChangeStatus({required this.status});
}

class WorkspaceEventCreateWorkspace extends WorkspaceEvent {
  final String name;
  final String description;

  WorkspaceEventCreateWorkspace({
    required this.name,
    required this.description,
  });
}

class WorkspaceEventUpdateWorkspace extends WorkspaceEvent {
  final String name;
  final String description;

  WorkspaceEventUpdateWorkspace({
    required this.name,
    required this.description,
  });
}

class WorkspaceEventDeleteWorkspace extends WorkspaceEvent {}

class WorkspaceEventWatchWorkspace extends WorkspaceEvent {}

class WorkspaceEventSelectedData extends WorkspaceEvent {
  final ModelWorkspace data;
  WorkspaceEventSelectedData({required this.data});
}
