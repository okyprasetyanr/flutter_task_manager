// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

class ModelWorkspaceMerge extends Equatable {
  final ModelWorkspace dataWorkspace;
  final List<ModelUser> dataWorkspaceMember;
  const ModelWorkspaceMerge({
    required this.dataWorkspace,
    required this.dataWorkspaceMember,
  });

  ModelWorkspaceMerge copyWith({
    ModelWorkspace? dataWorkspace,
    List<ModelUser>? dataWorkspaceMember,
  }) {
    return ModelWorkspaceMerge(
      dataWorkspace: dataWorkspace ?? this.dataWorkspace,
      dataWorkspaceMember: dataWorkspaceMember ?? this.dataWorkspaceMember,
    );
  }

  @override
  List<Object?> get props => [dataWorkspace, dataWorkspaceMember];
}
