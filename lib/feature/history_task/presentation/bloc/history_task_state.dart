import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/history_task/domain/model/model_task_history.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class HistoryTaskState {}

class HistoryTaskStateInitial extends HistoryTaskState {}

class HistoryTaskStateLoaded extends HistoryTaskState with EquatableMixin {
  final Set<ModelHistoryTask> dataHistoryTask;
  final EnumStatusState status;
  final ModelWorkspaceMerge? dataWorkspace;
  final Set<ModelUser>? dataUser;
  final String? failed;
  final String? error;
  final String? noconnection;

  HistoryTaskStateLoaded({
    this.dataHistoryTask = const {},
    this.status = EnumStatusState.none,
    this.dataUser = const {},
    this.failed,
    this.error,
    this.noconnection,
    this.dataWorkspace,
  });

  HistoryTaskStateLoaded copyWith({
    Set<ModelHistoryTask>? dataHistoryTask,
    EnumStatusState? status,
    Set<ModelUser>? dataUser,
    String? failed,
    String? error,
    String? noconnection,
    ModelWorkspaceMerge? workspace,
  }) {
    return HistoryTaskStateLoaded(
      dataUser: dataUser ?? this.dataUser,
      dataHistoryTask: dataHistoryTask ?? this.dataHistoryTask,
      error: error ?? this.error,
      failed: failed ?? this.failed,
      noconnection: noconnection ?? this.noconnection,
      status: status ?? this.status,
      dataWorkspace: workspace ?? this.dataWorkspace,
    );
  }

  @override
  List<Object?> get props => [
    dataHistoryTask,
    dataUser,
    error,
    failed,
    noconnection,
    status,
    dataWorkspace,
  ];
}
