import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_label.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';
import 'package:task_manager/shared/model/model_task.dart';

class ProjectDetailState {}

class ProjectDetailStateInitial extends ProjectDetailState {}

class ProjectDetailStateLoaded extends ProjectDetailState with EquatableMixin {
  final ModelProject? dataProject;
  final List<ModelUser> dataProjectMember;
  final List<ModelTask> dataTask;
  final List<ModelLabel> dataLabelTask;
  final EnumStatusState status;
  final String? error;
  final String? failed;
  final String? noconnection;

  ProjectDetailStateLoaded({
    this.dataProject,
    this.dataProjectMember = const [],
    this.dataTask = const [],
    this.dataLabelTask = const [],
    this.status = EnumStatusState.none,
    this.error,
    this.failed,
    this.noconnection,
  });

  ProjectDetailStateLoaded copyWith({
    ModelProject? dataProject,
    List<ModelUser>? dataProjectMember,
    List<ModelTask>? dataTask,
    List<ModelLabel>? dataLabelTask,
    EnumStatusState? status,
    String? error,
    String? failed,
    String? noconnection,
  }) {
    return ProjectDetailStateLoaded(
      dataLabelTask: dataLabelTask ?? this.dataLabelTask,
      dataProject: dataProject ?? this.dataProject,
      dataProjectMember: dataProjectMember ?? this.dataProjectMember,
      dataTask: dataTask ?? this.dataTask,
      error: error,
      failed: failed,
      noconnection: noconnection,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    dataProject,
    dataProjectMember,
    dataTask,
    dataLabelTask,
    status,
    error,
    failed,
    noconnection,
  ];
}
