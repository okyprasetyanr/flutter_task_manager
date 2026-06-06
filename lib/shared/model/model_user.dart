// ignore_for_file: non_constant_identifier_names
class ModelUser {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final DateTime createdAt;
  final String id_company;

  const ModelUser({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
    required this.id_company,
  });
}
