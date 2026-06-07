import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';

class ModelSubTask extends Equatable {
  final String id;
  final String taskId;
  final String title;
  final bool isDone;

  const ModelSubTask({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isDone,
  });

  factory ModelSubTask.fromJson(Map<String, dynamic> data) {
    return ModelSubTask(
      id: data[EnumSubTask.id.value],
      taskId: data[EnumSubTask.taskId.value],
      title: data[EnumSubTask.title.value],
      isDone: data[EnumSubTask.isDone.value],
    );
  }

  ModelSubTask copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? isDone,
  }) {
    return ModelSubTask(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [id, taskId, title, isDone];
}
