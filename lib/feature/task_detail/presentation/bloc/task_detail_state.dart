// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_comment.dart';
import 'package:task_manager/shared/model/model_label.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/model/model_task.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class TaskDetailState {}

class TaskDetailStateInitial extends TaskDetailState {}

class TaskDetailStateLoaded extends TaskDetailState with EquatableMixin {
  final ModelTask? dataTask;
  final List<ModelSubTask> dataSubTask;
  final List<ModelLabel> dataLabel;
  final EnumStatusState status;
  final List<ModelUser> dataUser;
  final List<ModelComment> dataComment;
  final String? failed;
  final String? error;
  final String? noconnection;

  TaskDetailStateLoaded({
    this.dataTask,
    this.dataSubTask = const [],
    this.dataLabel = const [],
    this.status = EnumStatusState.none,
    this.dataUser = const [],
    this.dataComment = const [],
    this.failed,
    this.error,
    this.noconnection,
  });

  TaskDetailStateLoaded copyWith({
    ModelTask? dataTask,
    List<ModelSubTask>? dataSubTask,
    List<ModelLabel>? dataLabel,
    EnumStatusState? status,
    List<ModelComment>? dataComment,
    List<ModelUser>? dataUser,
    String? failed,
    String? error,
    String? noconnection,
  }) {
    return TaskDetailStateLoaded(
      dataLabel: dataLabel ?? this.dataLabel,
      dataSubTask: dataSubTask ?? this.dataSubTask,
      dataTask: dataTask ?? this.dataTask,
      status: status ?? this.status,
      dataComment: dataComment ?? this.dataComment,
      dataUser: dataUser ?? this.dataUser,
      error: error ?? this.error,
      failed: failed ?? this.failed,
      noconnection: noconnection ?? this.noconnection,
    );
  }

  @override
  List<Object?> get props => [
    dataComment,
    dataLabel,
    dataTask,
    dataSubTask,
    dataUser,
    status,
    failed,
    error,
    noconnection,
  ];
}
