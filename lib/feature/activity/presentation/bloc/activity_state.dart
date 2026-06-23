import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/activity/domain/model/model_activity.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class ActivityState {}

class ActivityStateInitial extends ActivityState {}

class ActivityStateLoaded extends ActivityState with EquatableMixin {
  final Set<ModelActivity> dataActivity;
  final Set<ModelUser> dataUser;
  final ModelWorkspaceMerge? workspace;
  final EnumStatusState status;
  final String? failed;
  final String? error;
  final String? noconnection;

  ActivityStateLoaded({
    this.dataActivity = const {},
    this.dataUser = const {},
    this.workspace,
    this.status = EnumStatusState.none,
    this.failed,
    this.error,
    this.noconnection,
  });

  ActivityStateLoaded copyWith({
    Set<ModelActivity>? dataActivity,
    Set<ModelUser>? dataUser,
    ModelWorkspaceMerge? workspace,
    EnumStatusState? status,
    String? failed,
    String? error,
    String? noconnection,
  }) {
    return ActivityStateLoaded(
      dataActivity: dataActivity ?? this.dataActivity,
      dataUser: dataUser ?? this.dataUser,
      workspace: workspace ?? this.workspace,
      error: error ?? this.error,
      failed: failed ?? this.failed,
      noconnection: noconnection ?? this.noconnection,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    dataActivity,
    dataUser,
    workspace,
    status,
    failed,
    error,
    noconnection,
  ];
}
