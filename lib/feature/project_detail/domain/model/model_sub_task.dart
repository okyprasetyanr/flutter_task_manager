// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:uuid/uuid.dart';

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
      projectId: data[EnumSubtask.projectId.value],
      id: data[EnumSubtask.id.value],
      taskId: data[EnumSubtask.taskId.value],
      title: data[EnumSubtask.title.value],
      isDone: data[EnumSubtask.isDone.value],
    );
  }

  factory ModelSubTask.fromDrift(Map<String, dynamic> data) {
    return ModelSubTask(
      projectId: data[EnumSubtask.projectId.name],
      id: data[EnumSubtask.id.name],
      taskId: data[EnumSubtask.taskId.name],
      title: data[EnumSubtask.title.name],
      isDone: data[EnumSubtask.isDone.name],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumSubtask.projectId.value: projectId,
      EnumSubtask.id.value: id,
      EnumSubtask.taskId.value: taskId,
      EnumSubtask.title.value: title,
      EnumSubtask.isDone.value: isDone,
    };
  }

  static ModelSubTask createSubtask({
    required String title,
    required String taskId,
    required String projectId,
    required bool isDone,
  }) {
    return ModelSubTask(
      id: "SUB${Uuid().v4().substring(0, 6)}",
      taskId: taskId,
      title: title,
      isDone: isDone,
      projectId: projectId,
    );
  }

  static Map<String, dynamic> subtaskGetChangedData({
    required Map<String, dynamic> original,
    required Map<String, dynamic> edited,
  }) {
    Map<String, dynamic> changedData = {
      EnumSubtask.id.value: original[EnumSubtask.id.value],
    };

    edited.forEach((key, value) {
      if (original[key] != value) {
        changedData[key] = value;
      }
    });

    return changedData;
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
