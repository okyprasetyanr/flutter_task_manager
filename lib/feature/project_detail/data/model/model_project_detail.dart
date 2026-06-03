import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/project_detail/data/model/model_members.dart';
import 'package:task_manager/feature/project_detail/data/model/model_tasks.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum_project_detail.dart';
import 'package:task_manager/feature/main_menu/data/models/model_project.dart';

class ModelProjectDetail extends Equatable {
  final ModelProject? project;
  final List<ModelProjectMember> member;
  final List<ModelProjectTask> task;

  const ModelProjectDetail({
    this.project,
    this.member = const [],
    this.task = const [],
  });

  ModelProjectDetail copyWith({
    ModelProject? project,
    List<ModelProjectMember>? member,
    List<ModelProjectTask>? task,
  }) {
    return ModelProjectDetail(
      project: project ?? this.project,
      member: member ?? this.member,
      task: task ?? this.task,
    );
  }

  factory ModelProjectDetail.fromJson(Map<String, dynamic> data) {
    return ModelProjectDetail(
      member: (data[EnumModelProjectDetail.member.name] as List)
          .map((e) => ModelProjectMember.fromJson(e))
          .toList(),
      task: (data[EnumModelProjectDetail.task.name] as List)
          .map((e) => ModelProjectTask.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJsonProjectDetail() {
    return {
      EnumModelProjectDetail.project.name: project!.toJsonProject(),
      EnumModelProjectDetail.member.name: member
          .map((e) => e.toJsonMember())
          .toList(),
      EnumModelProjectDetail.task.name: task.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [project, member, task];
}
