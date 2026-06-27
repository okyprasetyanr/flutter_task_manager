// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_member.dart';

class ModelWorkspaceMerge extends Equatable {
  final ModelWorkspace dataWorkspace;
  final Set<ModelWorkspaceMember> dataMember;
  const ModelWorkspaceMerge({
    required this.dataWorkspace,
    required this.dataMember,
  });

  ModelWorkspaceMerge copyWith({
    ModelWorkspace? dataWorkspace,
    Set<ModelWorkspaceMember>? dataMember,
  }) {
    return ModelWorkspaceMerge(
      dataWorkspace: dataWorkspace ?? this.dataWorkspace,
      dataMember: dataMember ?? this.dataMember,
    );
  }

  @override
  List<Object?> get props => [dataWorkspace, dataMember];
}
