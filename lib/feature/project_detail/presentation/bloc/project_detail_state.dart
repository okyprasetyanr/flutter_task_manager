import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/main_menu/data/models/model_project.dart';
import 'package:task_manager/feature/project_detail/data/model/model_members.dart';
import 'package:task_manager/feature/project_detail/data/model/model_tasks.dart';

class ProjectDetailState {}

class ProjectDetailInisial extends ProjectDetailState {}

class ProjectDetailLoaded extends ProjectDetailState with EquatableMixin {
  final ModelProject? dataProject;
  final List<ModelProjectMember> dataMember;
  final List<ModelProjectTask> dataTask;

  ProjectDetailLoaded({
    this.dataProject,
    this.dataMember = const [],
    this.dataTask = const [],
  });

  ProjectDetailLoaded copyWith({
    ModelProject? dataProject,
    List<ModelProjectMember>? dataMember,
    List<ModelProjectTask>? dataTask,
  }) {
    return ProjectDetailLoaded(
      dataMember: dataMember ?? this.dataMember,
      dataProject: dataProject ?? this.dataProject,
      dataTask: dataTask ?? this.dataTask,
    );
  }

  @override
  List<Object?> get props => [dataProject, dataMember, dataTask];
}
