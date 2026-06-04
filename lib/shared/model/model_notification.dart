class ModelNotification {
  final String id;

  final String userId;

  final String title;
  final String body;

  final bool isRead;

  final DateTime createdAt;

  const ModelNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });
}
