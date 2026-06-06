import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_project.dart';
import 'package:task_manager/shared/model/model_workspace.dart';
import 'package:task_manager/shared/model/model_workspace_member.dart';

class WorkspaceDetailState {}

class WorkspaceDetailStateInitial extends WorkspaceDetailState {}

class WorkspaceDetailStateLoaded extends WorkspaceDetailState
    with EquatableMixin {
  final ModelWorkspace? dataWorkspace;
  final List<ModelWorkspaceMember> dataWorkspaceMember;
  final List<ModelProject> dataProject;
  final EnumStatusState status;
  final String? failed;
  final String? error;
  final String? noconnection;

  WorkspaceDetailStateLoaded({
    this.failed,
    this.error,
    this.noconnection,
    this.status = EnumStatusState.none,
    this.dataWorkspace,
    this.dataWorkspaceMember = const [],
    this.dataProject = const [],
  });

  WorkspaceDetailStateLoaded copyWith({
    String? workspaceName,
    String? companyName,
    String? failed,
    String? error,
    String? noconnection,
    ModelWorkspace? dataWorkspace,
    List<ModelWorkspaceMember>? dataWorkspaceMember,
    List<ModelProject>? dataProject,
    EnumStatusState? status,
  }) {
    return WorkspaceDetailStateLoaded(
      error: error,
      failed: failed,
      noconnection: noconnection,
      dataWorkspace: dataWorkspace ?? this.dataWorkspace,
      dataWorkspaceMember: dataWorkspaceMember ?? this.dataWorkspaceMember,
      dataProject: dataProject ?? this.dataProject,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    dataWorkspace,
    dataWorkspaceMember,
    dataProject,
    status,
    error,
    failed,
    noconnection,
  ];
}
