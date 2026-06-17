// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';

import 'package:task_manager/shared/enum/enum_status_state.dart';

class WorkspaceState {}

class WorkspaceStateInitial extends WorkspaceState {}

class WorkspaceStateLoaded extends WorkspaceState with EquatableMixin {
  final EnumStatusState status;
  final String? companyName;
  final String? failed;
  final String? error;
  final String? noconnection;
  final List<ModelWorkspaceMerge> dataWorkspace;
  final List<ModelUser> dataUser;
  final ModelWorkspaceMerge? selectedWorkspace;
  final bool? initMember;

  WorkspaceStateLoaded({
    this.selectedWorkspace,
    this.status = EnumStatusState.none,
    this.companyName,
    this.failed,
    this.error,
    this.noconnection,
    this.initMember,
    this.dataWorkspace = const [],
    this.dataUser = const [],
  });

  WorkspaceStateLoaded copyWith({
    ModelWorkspaceMerge? selectedWorkspace,
    EnumStatusState? status,
    List<ModelWorkspaceMerge>? dataWorkspace,
    List<ModelUser>? dataUser,
    String? companyName,
    String? failed,
    String? error,
    String? noconnection,
    bool? initMember,
  }) {
    return WorkspaceStateLoaded(
      dataUser: dataUser ?? this.dataUser,
      initMember: initMember ?? this.initMember,
      selectedWorkspace: selectedWorkspace,
      noconnection: noconnection,
      companyName: companyName ?? this.companyName,
      error: error,
      failed: failed,
      status: status ?? this.status,
      dataWorkspace: dataWorkspace ?? this.dataWorkspace,
    );
  }

  @override
  List<Object?> get props => [
    initMember,
    selectedWorkspace,
    companyName,
    status,
    dataWorkspace,
    dataUser,
    failed,
    error,
    noconnection,
  ];
}
