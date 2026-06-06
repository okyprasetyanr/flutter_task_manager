// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:task_manager/feature/workspace/domain/enum/workspace_enum_status_bloc.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

class WorkspaceState {}

class WorkspaceStateInitial extends WorkspaceState {}

class WorkspaceStateLoaded extends WorkspaceState with EquatableMixin {
  final WorkspaceEnumStatusBloc status;
  final String? companyName;
  final String? failed;
  final String? error;
  final String? noconnection;
  final List<ModelWorkspace> dataWorkspace;

  WorkspaceStateLoaded({
    this.status = WorkspaceEnumStatusBloc.none,
    this.companyName,
    this.failed,
    this.error,
    this.noconnection,
    this.dataWorkspace = const [],
  });

  WorkspaceStateLoaded copyWith({
    WorkspaceEnumStatusBloc? status,
    List<ModelWorkspace>? dataWorkspace,
    String? companyName,
    String? failed,
    String? error,
    String? noconnection,
  }) {
    return WorkspaceStateLoaded(
      noconnection: noconnection ?? this.noconnection,
      companyName: companyName ?? this.companyName,
      error: error ?? this.error,
      failed: failed ?? this.failed,
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
