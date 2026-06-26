// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:uuid/uuid.dart';

class ModelTaskLabels extends Equatable {
  final String id;
  final String taskId;
  final String labelId;
  final String projectId;

  const ModelTaskLabels({
    required this.id,
    required this.taskId,
    required this.labelId,
    required this.projectId,
  });

  factory ModelTaskLabels.fromJson(Map<String, dynamic> data) {
    return ModelTaskLabels(
      id: data[EnumTaskLabel.id.value],
      taskId: data[EnumTaskLabel.taskId.value],
      labelId: data[EnumTaskLabel.labelId.value],
      projectId: data[EnumTaskLabel.projectId.value],
    );
  }

  factory ModelTaskLabels.fromDrift(Map<String, dynamic> data) {
    return ModelTaskLabels(
      id: data[EnumTaskLabel.id.name],
      taskId: data[EnumTaskLabel.taskId.name],
      labelId: data[EnumTaskLabel.labelId.name],
      projectId: data[EnumTaskLabel.projectId.name],
    );
  }

  static ModelTaskLabels createTaskLabel({
    required String projectId,
    required String taskId,
    required String labelId,
  }) {
    return ModelTaskLabels(
      id: "TASL${Uuid().v4().substring(0, 6)}",
      taskId: taskId,
      labelId: labelId,
      projectId: projectId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumTaskLabel.id.value: id,
      EnumTaskLabel.taskId.value: taskId,
      EnumTaskLabel.labelId.value: labelId,
      EnumTaskLabel.projectId.value: projectId,
    };
  }

  @override
  List<Object?> get props => [id, taskId, labelId, projectId];
}
