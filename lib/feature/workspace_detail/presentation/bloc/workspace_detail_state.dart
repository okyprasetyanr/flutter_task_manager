import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_project.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/shared/model/model_project_member.dart';

class WorkspaceDetailState {}

class WorkspaceDetailStateInitial extends WorkspaceDetailState {}

class WorkspaceDetailStateLoaded extends WorkspaceDetailState
    with EquatableMixin {
  final ModelWorkspace? dataWorkspace;
  final List<ModelUser> dataUser;
  final List<ModelProject> dataProject;
  final EnumStatusState status;
  final bool initMember;
  final String? failed;
  final String? error;
  final String? noconnection;

  WorkspaceDetailStateLoaded({
    this.initMember = false,
    this.failed,
    this.error,
    this.noconnection,
    this.status = EnumStatusState.none,
    this.dataWorkspace,
    this.dataProject = const [],
    this.dataUser = const [],
  });

  WorkspaceDetailStateLoaded copyWith({
    String? workspaceName,
    String? failed,
    String? error,
    String? noconnection,
    ModelWorkspace? dataWorkspace,
    List<ModelUser>? dataUser,
    List<ModelProjectMember>? dataWorkspaceMember,
    List<ModelProject>? dataProject,
    EnumStatusState? status,
    bool? initMember,
  }) {
    return WorkspaceDetailStateLoaded(
      error: error,
      failed: failed,
      noconnection: noconnection,
      initMember: initMember ?? this.initMember,
      dataWorkspace: dataWorkspace ?? this.dataWorkspace,
      dataProject: dataProject ?? this.dataProject,
      status: status ?? this.status,
      dataUser: dataUser ?? this.dataUser,
    );
  }

  @override
  List<Object?> get props => [
    initMember,
    dataWorkspace,
    dataProject,
    dataUser,
    status,
    error,
    failed,
    noconnection,
  ];
}
