import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/main_menu/domain/enum/enum_project.dart';
import 'package:task_manager/shared/helper/common_helper.dart';

class ModelProject extends Equatable {
  final String projectName;
  final String projectId;
  final String projectType;
  final String projectStatus;
  final String projectCreatedBy;
  final String projectCreatedId;
  final int projectTotalContribut;
  final DateTime projectStart;
  final DateTime projectEnd;

  const ModelProject({
    required this.projectName,
    required this.projectId,
    required this.projectType,
    required this.projectStatus,
    required this.projectCreatedBy,
    required this.projectCreatedId,
    required this.projectTotalContribut,
    required this.projectStart,
    required this.projectEnd,
  });

  ModelProject copyWith({
    String? projectName,
    String? projectId,
    String? projectType,
    String? projectStatus,
    String? projectCreatedBy,
    String? projectCreatedId,
    int? projectTotalContribut,
    DateTime? projectStart,
    DateTime? projectEnd,
  }) {
    return ModelProject(
      projectName: projectName ?? this.projectName,
      projectId: projectId ?? this.projectId,
      projectType: projectType ?? this.projectType,
      projectStatus: projectStatus ?? this.projectStatus,
      projectCreatedBy: projectCreatedBy ?? this.projectCreatedBy,
      projectCreatedId: projectCreatedId ?? this.projectCreatedId,
      projectTotalContribut:
          projectTotalContribut ?? this.projectTotalContribut,
      projectStart: projectStart ?? this.projectStart,
      projectEnd: projectEnd ?? this.projectEnd,
    );
  }

  factory ModelProject.fromJson(Map<String, dynamic> data) {
    return ModelProject(
      projectName: data[EnumModelProject.projectName.name],
      projectId: data[EnumModelProject.projectId.name],
      projectType: data[EnumModelProject.projectType.name],
      projectStatus: data[EnumModelProject.projectStatus.name],
      projectCreatedBy: data[EnumModelProject.projectCreatedBy.name],
      projectCreatedId: data[EnumModelProject.projectCreatedId.name],
      projectTotalContribut: data[EnumModelProject.projectTotalContribut.name],
      projectStart: parseDate(
        date: data[EnumModelProject.projectStart.name],
        minute: false,
      ),
      projectEnd: parseDate(
        date: data[EnumModelProject.projectEnd.name],
        minute: false,
      ),
    );
  }

  Map<String, dynamic> toJsonProject() {
    return {
      EnumModelProject.projectName.name: projectName,
      EnumModelProject.projectId.name: projectId,
      EnumModelProject.projectType.name: projectType,
      EnumModelProject.projectStatus.name: projectStatus,
      EnumModelProject.projectCreatedBy.name: projectCreatedBy,
      EnumModelProject.projectCreatedId.name: projectCreatedId,
      EnumModelProject.projectTotalContribut.name: projectTotalContribut,
      EnumModelProject.projectStart.name: projectStart,
      EnumModelProject.projectEnd.name: projectEnd,
    };
  }

  @override
  List<Object?> get props => [
    projectName,
    projectId,
    projectType,
    projectStatus,
    projectCreatedBy,
    projectCreatedId,
    projectTotalContribut,
    projectStart,
    projectEnd,
  ];
}
