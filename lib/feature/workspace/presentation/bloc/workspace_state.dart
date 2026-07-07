// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';

import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class WorkspaceState {}

class WorkspaceStateInitial extends WorkspaceState {}

class WorkspaceStateLoaded extends WorkspaceState with EquatableMixin {
  final ModelUser? dataAccount;
  final EnumStatusState status;
  final String? companyName;
  final String? failed;
  final String? error;
  final String? noconnection;
  final Set<ModelWorkspaceMerge> dataWorkspace;
  final Set<ModelUser> dataUser;
  final Set<ModelUser> filteredUser;
  final ModelWorkspaceMerge? selectedWorkspace;
  final Set<ModelNotification> dataNotification;

  WorkspaceStateLoaded({
    this.dataAccount,
    this.status = EnumStatusState.none,
    this.companyName,
    this.failed,
    this.error,
    this.noconnection,
    this.dataWorkspace = const {},
    this.dataUser = const {},
    this.filteredUser = const {},
    this.dataNotification = const {},
    this.selectedWorkspace,
  });

  WorkspaceStateLoaded copyWith({
    ModelWorkspaceMerge? selectedWorkspace,
    EnumStatusState? status,
    Set<ModelWorkspaceMerge>? dataWorkspace,
    Set<ModelUser>? dataUser,
    Set<ModelUser>? filteredUser,
    String? companyName,
    String? failed,
    String? error,
    String? noconnection,
    ModelUser? dataAccount,
    Set<ModelNotification>? dataNotification,
  }) {
    return WorkspaceStateLoaded(
      dataNotification: dataNotification ?? this.dataNotification,
      dataAccount: dataAccount ?? this.dataAccount,
      filteredUser: filteredUser ?? this.filteredUser,
      dataUser: dataUser ?? this.dataUser,
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
    dataNotification,
    dataAccount,
    filteredUser,
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
