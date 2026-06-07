import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';

class ModelProjectMember extends Equatable {
  final String projectId;
  final String userId;
  final String role;

  const ModelProjectMember({
    required this.projectId,
    required this.userId,
    required this.role,
  });

  factory ModelProjectMember.fromJson(Map<String, dynamic> data) {
    return ModelProjectMember(
      projectId: data[EnumProjectMember.projectId.value],
      userId: data[EnumProjectMember.userId.value],
      role: data[EnumProjectMember.role.value],
    );
  }

  ModelProjectMember copyWith({
    String? projectId,
    String? userId,
    String? role,
  }) {
    return ModelProjectMember(
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [projectId, userId, role];
}
