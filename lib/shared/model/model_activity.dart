// ignore_for_file: non_constant_identifier_names
class ModelActivity {
  final String id;

  final String taskId;
  final String userId;

  final String action;

  final String oldValue;
  final String newValue;

  final DateTime createdAt;

  const ModelActivity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.action,
    required this.oldValue,
    required this.newValue,
    required this.createdAt,
  });
}
