import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:uuid/uuid.dart';

class ModelProjectMember extends Equatable {
  final String projectId;
  final String workspaceId;
  final String userId;
  final String role;
  final String id;

  const ModelProjectMember({
    required this.projectId,
    required this.workspaceId,
    required this.userId,
    required this.role,
    required this.id,
  });

  factory ModelProjectMember.fromJson(Map<String, dynamic> data) {
    return ModelProjectMember(
      id: data[EnumProjectMember.id.value],
      workspaceId: data[EnumProjectMember.workspaceId.value],
      projectId: data[EnumProjectMember.projectId.value],
      userId: data[EnumProjectMember.userId.value],
      role: data[EnumProjectMember.role.value],
    );
  }

  ModelProjectMember copyWith({
    String? projectId,
    String? workspaceId,
    String? userId,
    String? role,
    String? id,
  }) {
    return ModelProjectMember(
      workspaceId: workspaceId ?? this.workspaceId,
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }

  static ModelProjectMember createProjectMember({
    required String projectId,
    required String workspaceId,
    required String userId,
    required String role,
  }) {
    return ModelProjectMember(
      projectId: projectId,
      workspaceId: workspaceId,
      userId: userId,
      role: role,
      id: "USR${Uuid().v4().substring(0, 6)}",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumProjectMember.id.value: id,
      EnumProjectMember.projectId.value: projectId,
      EnumProjectMember.role.value: role,
      EnumProjectMember.userId.value: userId,
      EnumProjectMember.workspaceId.value: workspaceId,
    };
  }

  @override
  List<Object?> get props => [id, projectId, userId, role, workspaceId];
}
