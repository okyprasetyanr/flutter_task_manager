import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/user/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:uuid/uuid.dart';

class ModelUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
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

  factory ModelUser.fromDrift(Map<String, dynamic> data) {
    return ModelUser(
      id: data[EnumUser.id.name],
      name: data[EnumUser.name.name],
      email: data[EnumUser.email.name],
      photoUrl: data[EnumUser.photoUrl.name],
      createdAt: HelperDateConvert.toDateTime(data[EnumUser.createdAt.name]),
      companyId: data[EnumUser.companyId.name],
    );
  }

  static Map<String, dynamic> userGetChangedData({
    required Map<String, dynamic> original,
    required Map<String, dynamic> edited,
  }) {
    Map<String, dynamic> changedData = {
      EnumUser.id.value: original[EnumUser.id.value],
    };

    edited.forEach((key, value) {
      if (original[key] != value) {
        changedData[key] = value;
      }
    });

    return changedData;
  }

  Map<String, dynamic> toJson() {
    return {
      EnumUser.id.value: id,
      EnumUser.name.value: name,
      EnumUser.email.value: email,
      EnumUser.photoUrl.value: photoUrl,
      EnumUser.createdAt.value: HelperDateConvert.toJsonISO(createdAt),
      EnumUser.companyId.value: companyId,
    };
  }

  static ModelUser createUser({
    required String name,
    required String email,
    required String companyId,
  }) {
    return ModelUser(
      id: "USR${Uuid().v4().substring(0, 6)}",
      name: name,
      email: email,
      photoUrl: null,
      createdAt: DateTime.now(),
      companyId: companyId,
    );
  }

  ModelUser copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    String? companyId,
  }) {
    return ModelUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  List<Object?> get props => [id, name, email, photoUrl, createdAt, companyId];
}
