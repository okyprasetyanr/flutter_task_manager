import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_member.dart';

class ModelProjectMerge extends Equatable {
  final ModelProject dataProject;
  final Set<ModelProjectMember> dataMember;

  const ModelProjectMerge({
    required this.dataProject,
    required this.dataMember,
  });

  ModelProjectMerge copyWith({
    ModelProject? dataProject,
    Set<ModelProjectMember>? dataMember,
  }) {
    return ModelProjectMerge(
      dataProject: dataProject ?? this.dataProject,
      dataMember: dataMember ?? this.dataMember,
    );
  }

  @override
  List<Object?> get props => [dataProject, dataMember];
}
