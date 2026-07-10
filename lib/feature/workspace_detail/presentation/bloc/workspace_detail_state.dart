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
  final ModelUser? dataAccount;
  final Set<ModelUser> dataUser;
  final Set<ModelUser> filteredUser;
  final Set<ModelProjectMerge> dataProject;
  final Set<ModelProjectMerge> userAssignedProject;
  final Set<ModelProjectMerge> filteredUserAssignedProject;
  final EnumStatusState status;
  final String? failed;
  final String? error;
  final String? noconnection;
  final ModelProjectMerge? selectedProject;
  final String? selectedType;
  final Set<String> dataType;
  final Set<ModelProjectMerge> filteredProject;

  WorkspaceDetailStateLoaded({
    this.selectedProject,
    this.dataAccount,
    this.failed,
    this.error,
    this.noconnection,
    this.status = EnumStatusState.none,
    this.workspace,
    this.dataProject = const {},
    this.userAssignedProject = const {},
    this.filteredUserAssignedProject = const {},
    this.dataUser = const {},
    this.filteredUser = const {},
    this.dataType = const {},
    this.filteredProject = const {},
    this.selectedType,
  });

  WorkspaceDetailStateLoaded copyWith({
    ModelProjectMerge? selectedProject,
    String? workspaceName,
    String? failed,
    String? error,
    String? noconnection,
    ModelWorkspaceMerge? workspace,
    Set<ModelUser>? dataUser,
    Set<ModelUser>? filteredUser,
    Set<ModelProjectMerge>? dataProject,
    Set<ModelProjectMerge>? userAssignedProject,
    Set<ModelProjectMerge>? filteredUserAssignedProject,
    EnumStatusState? status,
    String? selectedType,
    Set<ModelProjectMerge>? filteredProject,
    Set<String>? dataType,
    ModelUser? dataAccount,
  }) {
    return WorkspaceDetailStateLoaded(
      filteredUserAssignedProject:
          filteredUserAssignedProject ?? this.filteredUserAssignedProject,
      userAssignedProject: userAssignedProject ?? this.userAssignedProject,
      dataAccount: dataAccount ?? this.dataAccount,
      dataType: dataType ?? this.dataType,
      filteredProject: filteredProject ?? this.filteredProject,
      selectedType: selectedType ?? this.selectedType,
      filteredUser: filteredUser ?? this.filteredUser,
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
    filteredUserAssignedProject,
    userAssignedProject,
    dataAccount,
    filteredProject,
    dataType,
    selectedType,
    filteredUser,
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
