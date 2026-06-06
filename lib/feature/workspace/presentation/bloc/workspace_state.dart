// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

class WorkspaceState {}

class WorkspaceStateInitial extends WorkspaceState {}

class WorkspaceStateLoaded extends WorkspaceState with EquatableMixin {
  final EnumStatusState status;
  final String? companyName;
  final String? failed;
  final String? error;
  final String? noconnection;
  final List<ModelWorkspace> dataWorkspace;

  WorkspaceStateLoaded({
    this.status = EnumStatusState.none,
    this.companyName,
    this.failed,
    this.error,
    this.noconnection,
    this.dataWorkspace = const [],
  });

  WorkspaceStateLoaded copyWith({
    EnumStatusState? status,
    List<ModelWorkspace>? dataWorkspace,
    String? companyName,
    String? failed,
    String? error,
    String? noconnection,
  }) {
    return WorkspaceStateLoaded(
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
    companyName,
    status,
    dataWorkspace,
    failed,
    error,
    noconnection,
  ];
}
