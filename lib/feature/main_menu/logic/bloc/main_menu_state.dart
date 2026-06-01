import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/main_menu/models/model_project.dart';

class MainMenuState {}

class MainMenuInitial extends MainMenuState {}

class MainMenuLoaded extends MainMenuState with EquatableMixin {
  final List<ModelProject> dataProject;
  final ModelProject? selectedProject;

  MainMenuLoaded({this.dataProject = const [], this.selectedProject});

  MainMenuLoaded copyWith({
    List<ModelProject>? dataProject,
    ModelProject? selectedProject,
  }) {
    return MainMenuLoaded(
      dataProject: dataProject ?? this.dataProject,
      selectedProject: selectedProject ?? this.selectedProject,
    );
  }

  @override
  List<Object?> get props => [dataProject, selectedProject];
}
