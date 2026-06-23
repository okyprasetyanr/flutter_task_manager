import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/workspace/domain/enum/enum.dart';
import 'package:uuid/uuid.dart';

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

  factory ModelWorkspaceMember.fromDrift(Map<String, dynamic> data) {
    return ModelWorkspaceMember(
      workspaceId: data[EnumWorkspaceMember.workspaceId.name],
      companyId: data[EnumWorkspaceMember.companyId.name],
      id: data[EnumWorkspaceMember.id.name],
      userId: data[EnumWorkspaceMember.userId.name],
      role: EnumWorkspaceRoleX.fromText(data[EnumWorkspaceMember.role.name]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumWorkspaceMember.workspaceId.name: workspaceId,
      EnumWorkspaceMember.companyId.name: companyId,
      EnumWorkspaceMember.id.name: id,
      EnumWorkspaceMember.userId.name: userId,
      EnumWorkspaceMember.role.name: role.name,
    };
  }

  static ModelWorkspaceMember createWorkspaceMember({
    required String workspaceId,
    required String companyId,
    required String userId,
    required EnumWorkspaceRole role,
  }) {
    return ModelWorkspaceMember(
      workspaceId: workspaceId,
      id: "PRJM${Uuid().v4().substring(0, 6)}",
      companyId: companyId,
      userId: userId,
      role: role,
    );
  }

  @override
  List<Object?> get props => [workspaceId, userId, role, companyId, id];
}
