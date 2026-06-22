import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class WorkspaceDetailState {}

class WorkspaceDetailStateInitial extends WorkspaceDetailState {}

class WorkspaceDetailStateLoaded extends WorkspaceDetailState
    with EquatableMixin {
  final ModelWorkspaceMerge? workspace;
  final Set<ModelUser> dataUser;
  final Set<ModelProjectMerge> dataProject;
  final EnumStatusState status;
  final String? failed;
  final String? error;
  final String? noconnection;
  final ModelProjectMerge? selectedProject;

  WorkspaceDetailStateLoaded({
    this.selectedProject,
    this.failed,
    this.error,
    this.noconnection,
    this.status = EnumStatusState.none,
    this.workspace,
    this.dataProject = const {},
    this.dataUser = const {},
  });

  WorkspaceDetailStateLoaded copyWith({
    ModelProjectMerge? selectedProject,
    String? workspaceName,
    String? failed,
    String? error,
    String? noconnection,
    ModelWorkspaceMerge? workspace,
    Set<ModelUser>? dataUser,
    Set<ModelProjectMerge>? dataProject,
    EnumStatusState? status,
  }) {
    return WorkspaceDetailStateLoaded(
      selectedProject: selectedProject,
      error: error,
      failed: failed,
      noconnection: noconnection,
      workspace: workspace ?? this.workspace,
      dataProject: dataProject ?? this.dataProject,
      status: status ?? this.status,
      dataUser: dataUser ?? this.dataUser,
    );
  }

  @override
  List<Object?> get props => [
    selectedProject,
    workspace,
    dataProject,
    dataUser,
    status,
    error,
    failed,
    noconnection,
  ];
}
