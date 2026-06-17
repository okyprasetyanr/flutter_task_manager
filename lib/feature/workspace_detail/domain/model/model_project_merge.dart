import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';

class ModelProjectMerge extends Equatable {
  final ModelProject dataProject;
  final List<ModelUser> dataProjectMember;

  const ModelProjectMerge({
    required this.dataProject,
    required this.dataProjectMember,
  });

  ModelProjectMerge copyWith({
    ModelProject? dataProject,
    List<ModelUser>? dataProjectMember,
  }) {
    return ModelProjectMerge(
      dataProject: dataProject ?? this.dataProject,
      dataProjectMember: dataProjectMember ?? this.dataProjectMember,
    );
  }

  @override
  List<Object?> get props => [dataProject, dataProjectMember];
}
