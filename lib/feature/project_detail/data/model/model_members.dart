// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:task_manager/feature/project_detail/domain/enum/enum_member.dart';

class ModelProjectMember extends Equatable {
  final String userId;
  final String name;
  final String role;
  final String idProject;

  const ModelProjectMember({
    required this.userId,
    required this.name,
    required this.role,
    required this.idProject,
  });

  ModelProjectMember copyWith({
    String? userId,
    String? name,
    String? role,
    String? idProject,
  }) {
    return ModelProjectMember(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      role: role ?? this.role,
      idProject: idProject ?? this.idProject,
    );
  }

  factory ModelProjectMember.fromJson(Map<String, dynamic> data) {
    return ModelProjectMember(
      userId: data[EnumModelMember.userId.name],
      name: data[EnumModelMember.name.name],
      role: data[EnumModelMember.role.name],
      idProject: data[EnumModelMember.id_project.name],
    );
  }

  Map<String, dynamic> toJsonMember() {
    return {
      EnumModelMember.userId.name: userId,
      EnumModelMember.name.name: name,
      EnumModelMember.role.name: role,
      EnumModelMember.id_project.name: idProject,
    };
  }

  @override
  List<Object?> get props => [userId, name, role, idProject];
}
