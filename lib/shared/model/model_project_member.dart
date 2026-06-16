import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';

class ModelProjectMember extends Equatable {
  final String projectId;
  final String userId;
  final String role;
  final String id;

  const ModelProjectMember({
    required this.projectId,
    required this.userId,
    required this.role,
    required this.id,
  });

  factory ModelProjectMember.fromJson(Map<String, dynamic> data) {
    return ModelProjectMember(
      id: data[EnumProjectMember.id.value],
      projectId: data[EnumProjectMember.projectId.value],
      userId: data[EnumProjectMember.userId.value],
      role: data[EnumProjectMember.role.value],
    );
  }

  ModelProjectMember copyWith({
    String? projectId,
    String? userId,
    String? role,
    String? id,
  }) {
    return ModelProjectMember(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, projectId, userId, role];
}
