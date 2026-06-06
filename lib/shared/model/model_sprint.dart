class ModelSprint {
  final String sprintId;
  final String projectId;
  final String sprintName;
  final String sprintGoal;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const ModelSprint({
    required this.sprintId,
    required this.projectId,
    required this.sprintName,
    required this.sprintGoal,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });
}
