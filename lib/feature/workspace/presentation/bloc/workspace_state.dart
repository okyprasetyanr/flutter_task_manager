// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

class WorkspaceState {}

class WorkspaceStateInitial extends WorkspaceState {}

class WorkspaceStateLoaded extends WorkspaceState with EquatableMixin {
  final EnumStatusState status;
  final String? companyName;
  final String? failed;
  final String? error;
  final String? noconnection;
  final List<ModelWorkspace> dataWorkspace;
  final ModelWorkspace? selectedWorkspace;

  WorkspaceStateLoaded({
    this.selectedWorkspace,
    this.status = EnumStatusState.none,
    this.companyName,
    this.failed,
    this.error,
    this.noconnection,
    this.dataWorkspace = const [],
  });

  WorkspaceStateLoaded copyWith({
    ModelWorkspace? selectedWorkspace,
    EnumStatusState? status,
    List<ModelWorkspace>? dataWorkspace,
    String? companyName,
    String? failed,
    String? error,
    String? noconnection,
  }) {
    return WorkspaceStateLoaded(
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
    selectedWorkspace,
    companyName,
    status,
    dataWorkspace,
    failed,
    error,
    noconnection,
  ];
}
