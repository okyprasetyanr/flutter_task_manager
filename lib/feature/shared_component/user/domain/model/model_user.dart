import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final DateTime createdAt;
  final String companyId;

  const ModelUser({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
    required this.companyId,
  });

  factory ModelUser.fromJson(Map<String, dynamic> data) {
    return ModelUser(
      id: data[EnumUser.id.value],
      name: data[EnumUser.name.value],
      email: data[EnumUser.email.value],
      photoUrl: data[EnumUser.photoUrl.value],
      createdAt: HelperDateConvert.toDateTime(data[EnumUser.createdAt.value]),
      companyId: data[EnumUser.companyId.value],
    );
  }

  @override
  List<Object?> get props => [id, name, email, photoUrl, createdAt, companyId];
}
