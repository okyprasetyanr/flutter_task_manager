// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:task_manager/feature/project_detail/domain/enum/enum_task.dart';
import 'package:task_manager/shared/helper/common_helper.dart';

class ModelProjectTask extends Equatable {
  final String taskId;
  final String title;
  final String description;
  final EnumTaskStatus? status;
  final EnumTaskPriority? priority;
  final String assignedTo;
  final DateTime dueDate;
  final String idProject;

  const ModelProjectTask({
    required this.taskId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.assignedTo,
    required this.dueDate,
    required this.idProject,
  });

  ModelProjectTask copyWith({
    String? taskId,
    String? title,
    String? description,
    EnumTaskStatus? status,
    EnumTaskPriority? priority,
    String? assignedTo,
    DateTime? dueDate,
    String? idProject,
  }) {
    return ModelProjectTask(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      dueDate: dueDate ?? this.dueDate,
      idProject: idProject ?? this.idProject,
    );
  }

  factory ModelProjectTask.fromJson(Map<String, dynamic> data) {
    return ModelProjectTask(
      taskId: data[EnumModelTask.taskId.name],
      title: data[EnumModelTask.title.name],
      description: data[EnumModelTask.description.name],
      status: EnumTaskStatusX.fromTaskStatus(
        (data[EnumModelTask.status.name] as String),
      ),
      priority: EnumTaskPriorityX.fromTaskPriority(
        data[EnumModelTask.priority.name],
      ),
      assignedTo: data[EnumModelTask.assignedTo.name],
      dueDate: parseDate(date: data[EnumModelTask.dueDate.name], minute: false),
      idProject: data[EnumModelTask.id_project.name],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumModelTask.taskId.name: taskId,
      EnumModelTask.title.name: title,
      EnumModelTask.description.name: description,
      EnumModelTask.status.name: status,
      EnumModelTask.priority.name: priority,
      EnumModelTask.assignedTo.name: assignedTo,
      EnumModelTask.dueDate.name: dueDate,
      EnumModelTask.id_project.name: idProject,
    };
  }

  @override
  List<Object?> get props => [
    taskId,
    title,
    description,
    status,
    priority,
    assignedTo,
    dueDate,
    idProject,
  ];
}
