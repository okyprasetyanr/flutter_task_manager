import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_activity.dart';
import 'package:task_manager/shared/model/model_user.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

class ActivityState {}

class ActivityStateInitial extends ActivityState {}

class ActivityStateLoaded extends ActivityState with EquatableMixin {
  final List<ModelActivity> dataActivity;
  final List<ModelUser> dataUser;
  final ModelWorkspace? dataWorkspace;
  final EnumStatusState status;
  final String? failed;
  final String? error;
  final String? noconnection;

  ActivityStateLoaded({
    this.dataActivity = const [],
    this.dataUser = const [],
    this.dataWorkspace,
    this.status = EnumStatusState.none,
    this.failed,
    this.error,
    this.noconnection,
  });

  ActivityStateLoaded copyWith({
    List<ModelActivity>? dataActivity,
    List<ModelUser>? dataUser,
    ModelWorkspace? dataWorkspace,
    EnumStatusState? status,
    String? failed,
    String? error,
    String? noconnection,
  }) {
    return ActivityStateLoaded(
      dataActivity: dataActivity ?? this.dataActivity,
      dataUser: dataUser ?? this.dataUser,
      dataWorkspace: dataWorkspace ?? this.dataWorkspace,
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
    dataWorkspace,
    status,
    failed,
    error,
    noconnection,
  ];
}
