// ignore_for_file: non_constant_identifier_names
class ModelTask {
  final String id;

  final String projectId;
  final String? sprintId;

  final String title;
  final String description;

  final String status;
  final String priority;

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
}
