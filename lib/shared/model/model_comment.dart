// ignore_for_file: non_constant_identifier_names
class ModelComment {
  final String id;

  final String taskId;
  final String userId;

  final String content;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ModelComment({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}
