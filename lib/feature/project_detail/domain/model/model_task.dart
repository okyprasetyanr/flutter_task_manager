// ignore_for_file: public_member_api_docs??this.public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:uuid/uuid.dart';

class ModelTask extends Equatable {
  final String id;
  final String projectId;
  final String? sprintId;
  final String title;
  final String description;
  final EnumTaskStatus status;
  final EnumTaskPriority priority;
  final int storyPoint;
  final String reporterId;
  final String assigneeId;
  final DateTime startDate;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ModelTask({
    required this.id,
    required this.projectId,
    this.sprintId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.storyPoint,
    required this.reporterId,
    required this.assigneeId,
    required this.startDate,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelTask.fromJson(Map<String, dynamic> data) {
    return ModelTask(
      id: data[EnumTask.id.value],
      projectId: data[EnumTask.projectId.value],
      title: data[EnumTask.title.value],
      description: data[EnumTask.description.value],
      status: EnumTaskStatusX.fromServer(data[EnumTask.status.value]),
      priority: EnumTaskPriorityX.fromServer(data[EnumTask.priority.value]),
      storyPoint: data[EnumTask.storyPoint.value],
      reporterId: data[EnumTask.reporterId.value],
      assigneeId: data[EnumTask.assigneeId.value],
      startDate: HelperDateConvert.toDateTime(data[EnumTask.startDate.value]),
      dueDate: HelperDateConvert.toDateTime(data[EnumTask.dueDate.value]),
      createdAt: HelperDateConvert.toDateTime(data[EnumTask.createdAt.value]),
      updatedAt: HelperDateConvert.toDateTime(data[EnumTask.updatedAt.value]),
    );
  }

  factory ModelTask.fromDrift(Map<String, dynamic> data) {
    return ModelTask(
      id: data[EnumTask.id.name],
      projectId: data[EnumTask.projectId.name],
      title: data[EnumTask.title.name],
      description: data[EnumTask.description.name],
      status: EnumTaskStatusX.fromServer(data[EnumTask.status.name]),
      priority: EnumTaskPriorityX.fromServer(data[EnumTask.priority.name]),
      storyPoint: data[EnumTask.storyPoint.name],
      reporterId: data[EnumTask.reporterId.name],
      assigneeId: data[EnumTask.assigneeId.name],
      startDate: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumTask.startDate.name]),
      ),
      dueDate: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumTask.dueDate.name]),
      ),
      createdAt: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumTask.createdAt.name]),
      ),
      updatedAt: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumTask.updatedAt.name]),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumTask.id.value: id,
      EnumTask.projectId.value: projectId,
      EnumTask.title.value: title,
      EnumTask.description.value: description,
      EnumTask.status.value: status.text,
      EnumTask.priority.value: priority.text,
      EnumTask.storyPoint.value: storyPoint,
      EnumTask.reporterId.value: reporterId,
      EnumTask.assigneeId.value: assigneeId,
      EnumTask.startDate.value: HelperDateConvert.toJsonISO(startDate),
      EnumTask.dueDate.value: HelperDateConvert.toJsonISO(dueDate),
      EnumTask.createdAt.value: HelperDateConvert.toJsonISO(createdAt),
      EnumTask.updatedAt.value: HelperDateConvert.toJsonISO(updatedAt),
    };
  }

  static Map<String, dynamic> taskGetChangedData({
    required Map<String, dynamic> original,
    required Map<String, dynamic> edited,
  }) {
    Map<String, dynamic> changedData = {
      EnumTask.id.value: original[EnumTask.id.value],
    };

    edited.forEach((key, value) {
      if (original[key] != value) {
        changedData[key] = value;
      }
    });

    return changedData;
  }

  static ModelTask createTask({
    required String projectId,
    required String? sprintId,
    required String title,
    required String description,
    required EnumTaskStatus status,
    required EnumTaskPriority priority,
    required int storyPoint,
    required String reporterId,
    required String assigneeId,
    required DateTime startDate,
    required DateTime dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return ModelTask(
      id: "TASK${Uuid().v4().substring(0, 6)}",
      projectId: projectId,
      title: title,
      description: description,
      status: status,
      priority: priority,
      storyPoint: storyPoint,
      reporterId: reporterId,
      assigneeId: assigneeId,
      startDate: startDate,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ModelTask copyWith({
    String? id,
    String? projectId,
    String? sprintId,
    String? title,
    String? description,
    EnumTaskStatus? status,
    EnumTaskPriority? priority,
    int? storyPoint,
    String? reporterId,
    String? assigneeId,
    DateTime? startDate,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ModelTask(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      storyPoint: storyPoint ?? this.storyPoint,
      reporterId: reporterId ?? this.reporterId,
      assigneeId: assigneeId ?? this.assigneeId,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    projectId,
    sprintId,
    title,
    description,
    status,
    priority,
    storyPoint,
    reporterId,
    assigneeId,
    startDate,
    dueDate,
    createdAt,
    updatedAt,
  ];
}
