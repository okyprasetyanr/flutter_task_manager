// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class WorkspaceEvent {}

class WorkspaceEventChangeStatus extends WorkspaceEvent {
  final EnumStatusState status;
  WorkspaceEventChangeStatus({required this.status});
}

class WorkspaceEventCreateWorkspace extends WorkspaceEvent {
  final String name;
  final String description;
  final Set<(ModelUser, EnumWorkspaceRole)> contributor;

  WorkspaceEventCreateWorkspace({
    required this.name,
    required this.description,
    required this.contributor,
  });
}

class WorkspaceEventUpdateWorkspace extends WorkspaceEvent {
  final String name;
  final String description;
  final Set<(ModelUser, EnumWorkspaceRole)> contributor;

  WorkspaceEventUpdateWorkspace({
    required this.name,
    required this.description,
    required this.contributor,
  });
}

class WorkspaceEventDeleteWorkspace extends WorkspaceEvent {}

class WorkspaceEventWatch extends WorkspaceEvent {}

class WorkspaceEventSelectedData extends WorkspaceEvent {
  final ModelWorkspaceMerge data;
  WorkspaceEventSelectedData({required this.data});
}

class WorkspaceEventResetSelected extends WorkspaceEvent {}

class WorkspaceEventSearchMember extends WorkspaceEvent {
  final String search;

  WorkspaceEventSearchMember({required this.search});
}

class WorkspaceEventCreateMember extends WorkspaceEvent {
  final String name;
  final String email;

  WorkspaceEventCreateMember({required this.name, required this.email});
}

class WorkspaceEventUpdateMember extends WorkspaceEvent {
  final String name;
  final String email;

  WorkspaceEventUpdateMember({required this.name, required this.email});
}

class WorkspaceEventDeleteMember extends WorkspaceEvent {}

class WorkspaceEventResetSelectedMember extends WorkspaceEvent {}

class WorkspaceEventSelectedMember extends WorkspaceEvent {
  final ModelUser data;

  WorkspaceEventSelectedMember({required this.data});
}
