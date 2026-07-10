// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class WorkspaceDetailEvent {}

class WorkspaceDetailEventWatch extends WorkspaceDetailEvent {
  final ModelWorkspaceMerge? data;

  WorkspaceDetailEventWatch({required this.data});
}

class WorkspaceDetailEventResetSelected extends WorkspaceDetailEvent {}

class WorkspaceDetailEventChangeStatus extends WorkspaceDetailEvent {
  final EnumStatusState status;

  WorkspaceDetailEventChangeStatus({required this.status});
}

class WorkspaceDetailEventCreateProject extends WorkspaceDetailEvent {
  final String name;
  final DateTime start;
  final DateTime end;
  final DateTime createdAt;
  final Set<(ModelUser, EnumProjectRole)> contributor;
  final EnumProjectType type;
  final EnumProjectStatus status;

  WorkspaceDetailEventCreateProject({
    required this.name,
    required this.start,
    required this.end,
    required this.createdAt,
    required this.contributor,
    required this.type,
    required this.status,
  });
}

class WorkspaceDetailEventUpdateProject extends WorkspaceDetailEvent {
  final DateTime start;
  final DateTime end;
  final DateTime createdAt;
  final Set<(ModelUser, EnumProjectRole)> contributor;
  final EnumProjectType type;
  final EnumProjectStatus status;

  WorkspaceDetailEventUpdateProject({
    required this.start,
    required this.end,
    required this.createdAt,
    required this.contributor,
    required this.type,
    required this.status,
  });
}

class WorkspaceDetailEventDeleteProject extends WorkspaceDetailEvent {}

class WorkspaceDetailEventSelectedProject extends WorkspaceDetailEvent {
  final ModelProjectMerge data;

  WorkspaceDetailEventSelectedProject({required this.data});
}

class WorkspaceDetailEventSearchMember extends WorkspaceDetailEvent {
  final String search;

  WorkspaceDetailEventSearchMember({required this.search});
}

class WorkspaceDetailEventSelectedFilterType extends WorkspaceDetailEvent {
  final String? type;

  WorkspaceDetailEventSelectedFilterType({required this.type});
}

class WorkspaceDetailEventSearchUserProject extends WorkspaceDetailEvent {
  final String search;

  WorkspaceDetailEventSearchUserProject({required this.search});
}

class WorkspaceDetailEventSearchProject extends WorkspaceDetailEvent {
  final String search;

  WorkspaceDetailEventSearchProject({required this.search});
}
