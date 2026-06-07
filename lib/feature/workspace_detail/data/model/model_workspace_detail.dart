import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/model/model_workspace.dart';
import 'package:task_manager/shared/model/model_workspace_member.dart';

class ModelWorkspaceDetail extends Equatable {
  final ModelWorkspace detailWorkspace;
  final List<ModelWorkspaceMember> workspaceMember;

  const ModelWorkspaceDetail({
    required this.detailWorkspace,
    required this.workspaceMember,
  });

  ModelWorkspaceDetail copyWith({
    ModelWorkspace? detailWorkspace,
    List<ModelWorkspaceMember>? workspaceMember,
  }) {
    return ModelWorkspaceDetail(
      detailWorkspace: detailWorkspace ?? this.detailWorkspace,
      workspaceMember: workspaceMember ?? this.workspaceMember,
    );
  }

  @override
  List<Object?> get props => [detailWorkspace, workspaceMember];
}
