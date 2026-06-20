// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class WorkspaceDetailEvent {}

class WorkspaceDetailEventWatch extends WorkspaceDetailEvent {
  final ModelWorkspaceMerge? data;

  WorkspaceDetailEventWatch({required this.data});
}

class WorkspaceDetailEventWatchMessage extends WorkspaceDetailEvent {
  final String workspaceId;

  WorkspaceDetailEventWatchMessage({required this.workspaceId});
}

class WorkspaceDetailEventWatchMember extends WorkspaceDetailEvent {
  final String workspaceId;
  WorkspaceDetailEventWatchMember({required this.workspaceId});
}

class WorkspaceDetailEventResetSelected extends WorkspaceDetailEvent {}

class WorkspaceDetailEventWatchMessageMember extends WorkspaceDetailEvent {}

class WorkspaceDetailEventWatchUser extends WorkspaceDetailEvent {}

class WorkspaceDetailEventChangeStatus extends WorkspaceDetailEvent {
  final EnumStatusState status;

  WorkspaceDetailEventChangeStatus({required this.status});
}

class WorkspaceDetailEventCreateProject extends WorkspaceDetailEvent {
  final String name;
  final DateTime start;
  final DateTime end;
  final DateTime createdAt;
  final Set<(ModelUser, String)> contributor;
  final String type;

  WorkspaceDetailEventCreateProject({
    required this.name,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.contributor,
    required this.type,
  });
}

class WorkspaceDetailEventUpdateProject extends WorkspaceDetailEvent {
  final String name;
  final DateTime start;
  final DateTime end;
  final DateTime createdAt;
  final Set<(ModelUser, String)> contributor;
  final String type;
  final EnumProjectStatus status;

  WorkspaceDetailEventUpdateProject({
    required this.name,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.contributor,
    required this.type,
    required this.status,
  });
}

class WorkspaceDetailEventDeleteProject extends WorkspaceDetailEvent {
  final String idProject;

  WorkspaceDetailEventDeleteProject({required this.idProject});
}

class WorkspaceDetailEventSelectedProject extends WorkspaceDetailEvent {
  final ModelProjectMerge data;

  WorkspaceDetailEventSelectedProject({required this.data});
}
