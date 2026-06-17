import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';

class ModelWorkspaceMember extends Equatable {
  final String workspaceId;
  final String userId;
  final EnumWorkspaceRole role;
  final String companyId;
  final String id;

  const ModelWorkspaceMember({
    required this.workspaceId,
    required this.id,
    required this.companyId,
    required this.userId,
    required this.role,
  });

  factory ModelWorkspaceMember.fromJson(Map<String, dynamic> data) {
    return ModelWorkspaceMember(
      workspaceId: data[EnumWorkspaceMember.workspaceId.value],
      companyId: data[EnumWorkspaceMember.companyId.value],
      id: data[EnumWorkspaceMember.id.value],
      userId: data[EnumWorkspaceMember.userId.value],
      role: EnumWorkspaceRoleX.fromText(data[EnumWorkspaceMember.role.value]),
    );
  }

  @override
  List<Object?> get props => [workspaceId, userId, role, companyId, id];
}
