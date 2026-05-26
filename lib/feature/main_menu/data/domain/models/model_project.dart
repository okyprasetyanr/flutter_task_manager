import 'package:equatable/equatable.dart';

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
