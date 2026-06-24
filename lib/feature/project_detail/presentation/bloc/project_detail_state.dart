import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';

class ProjectDetailState {}

class ProjectDetailStateInitial extends ProjectDetailState {}

class ProjectDetailStateLoaded extends ProjectDetailState with EquatableMixin {
  final ModelProjectMerge? dataProject;
  final Set<ModelTaskMerge> dataTask;
  final Set<ModelLabel> dataLabel;
  final Set<ModelUser> dataUser;
  final EnumStatusState status;
  final String? error;
  final String? failed;
  final String? noconnection;
  final ModelTaskMerge? selectedTask;

  ProjectDetailStateLoaded({
    this.dataProject,
    this.dataTask = const {},
    this.dataLabel = const {},
    this.dataUser = const {},
    this.status = EnumStatusState.none,
    this.error,
    this.failed,
    this.noconnection,
    this.selectedTask,
  });

  ProjectDetailStateLoaded copyWith({
    ModelProjectMerge? dataProject,
    Set<ModelTaskMerge>? dataTask,
    Set<ModelLabel>? dataLabel,
    EnumStatusState? status,
    ModelTaskMerge? selectedTask,
    String? error,
    String? failed,
    String? noconnection,
    Set<ModelUser>? dataUser,
  }) {
    return ProjectDetailStateLoaded(
      selectedTask: selectedTask ?? this.selectedTask,
      dataUser: dataUser ?? this.dataUser,
      dataLabel: dataLabel ?? this.dataLabel,
      dataProject: dataProject ?? this.dataProject,
      dataTask: dataTask ?? this.dataTask,
      error: error,
      failed: failed,
      noconnection: noconnection,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    selectedTask,
    dataUser,
    dataProject,
    dataTask,
    dataLabel,
    status,
    error,
    failed,
    noconnection,
  ];
}
