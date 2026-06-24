// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';

import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/task_detail/domain/model/model_comment.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';

class TaskDetailState {}

class TaskDetailStateInitial extends TaskDetailState {}

class TaskDetailStateLoaded extends TaskDetailState with EquatableMixin {
  final ModelTaskMerge? task;
  final EnumStatusState status;
  final Set<ModelUser> dataUser;
  final Set<ModelLabel> dataLabel;
  final Set<ModelComment> dataComment;
  final String? failed;
  final String? error;
  final String? noconnection;
  final ModelSubTask? selectedSubtask;

  TaskDetailStateLoaded({
    this.task,
    this.status = EnumStatusState.none,
    this.dataUser = const {},
    this.dataComment = const {},
    this.dataLabel = const {},
    this.failed,
    this.error,
    this.noconnection,
    this.selectedSubtask,
  });

  TaskDetailStateLoaded copyWith({
    ModelTaskMerge? task,
    EnumStatusState? status,
    Set<ModelComment>? dataComment,
    Set<ModelUser>? dataUser,
    Set<ModelLabel>? dataLabel,
    String? failed,
    String? error,
    String? noconnection,
    ModelSubTask? selectedSubtask,
  }) {
    return TaskDetailStateLoaded(
      dataLabel: dataLabel ?? this.dataLabel,
      task: task ?? this.task,
      status: status ?? this.status,
      dataComment: dataComment ?? this.dataComment,
      dataUser: dataUser ?? this.dataUser,
      error: error ?? this.error,
      failed: failed ?? this.failed,
      noconnection: noconnection ?? this.noconnection,
      selectedSubtask: selectedSubtask,
    );
  }

  @override
  List<Object?> get props => [
    dataLabel,
    dataComment,
    task,
    dataUser,
    status,
    failed,
    error,
    noconnection,
    selectedSubtask,
  ];
}
