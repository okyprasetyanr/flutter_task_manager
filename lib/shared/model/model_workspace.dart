class ModelWorkspace {
  final String workspaceId;
  final String workspaceName;
  final String workspaceDescription;
  final String workspaceOwnerId;
  final DateTime createdAt;
  final String uidOwner;

  const ModelWorkspace({
    required this.workspaceId,
    required this.workspaceName,
    required this.workspaceDescription,
    required this.workspaceOwnerId,
    required this.createdAt,
    required this.uidOwner,
  });
}
