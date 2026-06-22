// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';

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

  @override
  List<Object?> get props => [id, taskId, labelId, projectId];
}
