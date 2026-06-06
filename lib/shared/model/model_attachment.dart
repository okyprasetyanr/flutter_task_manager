class ModelAttachment {
  final String id;
  final String taskId;
  final String fileName;
  final String fileUrl;
  final int fileSize;
  final String uploadedBy;
  final DateTime uploadedAt;

  const ModelAttachment({
    required this.id,
    required this.taskId,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}
