// ignore_for_file: constant_identifier_names

enum EnumTaskStatus { Todo, In_Progress, Done }

enum EnumTaskPriority { Low, Medium, High }

enum EnumModelTask {
  taskId,
  title,
  description,
  status,
  priority,
  assignedTo,
  dueDate,
  id_project,
}

extension EnumTaskStatusX on EnumTaskStatus {
  static EnumTaskStatus? fromTaskStatus(String value) {
    try {
      return EnumTaskStatus.values.firstWhere(
        (element) => element.name == value,
      );
    } catch (_) {
      return null;
    }
  }
}

extension EnumTaskPriorityX on EnumTaskPriority {
  static EnumTaskPriority? fromTaskPriority(String value) {
    try {
      return EnumTaskPriority.values.firstWhere(
        (element) => element.name == value,
      );
    } catch (_) {
      return null;
    }
  }
}
