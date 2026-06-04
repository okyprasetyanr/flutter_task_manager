class ModelProject {
  final String projectId;
  final String projectName;
  final String projectType;
  final String projectStatus;

  final String projectCreatedBy;
  final String projectCreatedId;

  final int projectTotalContribut;

  final DateTime projectStart;
  final DateTime projectEnd;

  const ModelProject({
    required this.projectId,
    required this.projectName,
    required this.projectType,
    required this.projectStatus,
    required this.projectCreatedBy,
    required this.projectCreatedId,
    required this.projectTotalContribut,
    required this.projectStart,
    required this.projectEnd,
  });
}
