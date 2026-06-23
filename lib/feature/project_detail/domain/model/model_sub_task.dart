// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';

class ModelSubTask extends Equatable {
  final String id;
  final String taskId;
  final String title;
  final bool isDone;
  final String projectId;

  const ModelSubTask({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isDone,
    required this.projectId,
  });

  factory ModelSubTask.fromJson(Map<String, dynamic> data) {
    return ModelSubTask(
      projectId: data[EnumSubTask.projectId.value],
      id: data[EnumSubTask.id.value],
      taskId: data[EnumSubTask.taskId.value],
      title: data[EnumSubTask.title.value],
      isDone: data[EnumSubTask.isDone.value],
    );
  }

  factory ModelSubTask.fromDrift(Map<String, dynamic> data) {
    return ModelSubTask(
      projectId: data[EnumSubTask.projectId.name],
      id: data[EnumSubTask.id.name],
      taskId: data[EnumSubTask.taskId.name],
      title: data[EnumSubTask.title.name],
      isDone: data[EnumSubTask.isDone.name],
    );
  }

  ModelSubTask copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? isDone,
    String? projectId,
  }) {
    return ModelSubTask(
      projectId: projectId ?? this.projectId,
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [id, taskId, title, isDone, projectId];
}
