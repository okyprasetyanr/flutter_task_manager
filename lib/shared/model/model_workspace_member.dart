import 'package:task_manager/shared/enum.dart';

class ModelWorkspaceMember {
  final String workspaceId;
  final String userId;
  final EnumWorkspaceRole role;

  const ModelWorkspaceMember({
    required this.workspaceId,
    required this.userId,
    required this.role,
  });

  factory ModelWorkspaceMember.fromJson(Map<String, dynamic> data) {
    return ModelWorkspaceMember(
      workspaceId: data[EnumWorkspaceMember.workspaceId.value],
      userId: data[EnumWorkspaceMember.userId.value],
      role: EnumWorkspaceRoleX.fromText(data[EnumWorkspaceMember.role.value]),
    );
  }
}
