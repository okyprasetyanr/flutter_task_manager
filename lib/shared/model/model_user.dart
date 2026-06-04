class ModelUser {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final DateTime createdAt;
  final String uidOwner;

  const ModelUser({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
    required this.uidOwner,
  });
}
