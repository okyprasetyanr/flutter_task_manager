import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_member.dart';

class ModelWorkspaceMemberMerge extends Equatable {
  final Set<ModelWorkspaceMember> dataWorkspaceMember;
  final Set<ModelUser> dataUser;

  const ModelWorkspaceMemberMerge({
    required this.dataWorkspaceMember,
    required this.dataUser,
  });

  ModelWorkspaceMemberMerge copyWith({
    Set<ModelWorkspaceMember>? dataWorkspaceMember,
    Set<ModelUser>? dataUser,
  }) {
    return ModelWorkspaceMemberMerge(
      dataWorkspaceMember: dataWorkspaceMember ?? this.dataWorkspaceMember,
      dataUser: dataUser ?? this.dataUser,
    );
  }

  @override
  List<Object?> get props => [dataWorkspaceMember, dataUser];
}
