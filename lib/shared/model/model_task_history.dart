class ModelTaskHistory {
  final String id;
  final String taskId;

  /// status, priority, assigneeId, dueDate, title, dll
  final String field;

  final String oldValue;

  final String newValue;

  final String changedBy;

  final DateTime changedAt;

  const ModelTaskHistory({
    required this.id,
    required this.taskId,
    required this.field,
    required this.oldValue,
    required this.newValue,
    required this.changedBy,
    required this.changedAt,
  });
}
