enum EnumTaskPriority {
  lowest('lowest'),
  low('low'),
  medium('medium'),
  high('high'),
  highest('highest');

  final String value;
  const EnumTaskPriority(this.value);
}

extension EnumTaskPriorityX on EnumTaskPriority {
  static EnumTaskPriority fromServer(String value) =>
      EnumTaskPriority.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumTaskPriority.medium,
      );

  String get text {
    switch (this) {
      case EnumTaskPriority.lowest:
        return "Lowest";
      case EnumTaskPriority.low:
        return "Low";
      case EnumTaskPriority.medium:
        return "Medium";
      case EnumTaskPriority.high:
        return "High";
      case EnumTaskPriority.highest:
        return "Highest";
    }
  }

  static EnumTaskPriority fromText(String value) =>
      EnumTaskPriority.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumTaskPriority.medium,
      );
}

enum EnumTask {
  id('id'),
  projectId('project_id'),
  sprintId('sprint_id'),
  title('title'),
  description('description'),
  status('status'),
  priority('priority'),
  storyPoint('story_point'),
  reporterId('reporter_id'),
  assigneeId('assignee_id'),
  startDate('start_date'),
  dueDate('due_date'),
  createdAt('created_at'),
  updatedAt('updated_at');

  final String value;
  const EnumTask(this.value);
}

enum EnumSubtask {
  id('id'),
  taskId('task_id'),
  title('title'),
  isDone('is_done'),
  projectId('project_id');

  final String value;
  const EnumSubtask(this.value);
}

enum EnumLabel {
  id('id'),
  name('name'),
  color('color'),
  companyId('company_id');

  final String value;
  const EnumLabel(this.value);
}

enum EnumTaskLabel {
  id('id'),
  taskId('task_id'),
  labelId('label_id'),
  projectId('project_id');

  final String value;
  const EnumTaskLabel(this.value);
}

enum EnumTaskStatus {
  todo('todo'),
  inProgress('in_progress'),
  review('review'),
  done('done'),
  cancelled('cancelled');

  final String value;
  const EnumTaskStatus(this.value);
}

extension EnumTaskStatusX on EnumTaskStatus {
  static EnumTaskStatus fromServer(String value) => EnumTaskStatus.values
      .firstWhere((e) => e.text == value, orElse: () => EnumTaskStatus.todo);

  String get text {
    switch (this) {
      case EnumTaskStatus.todo:
        return "Todo";
      case EnumTaskStatus.inProgress:
        return "In Progress";
      case EnumTaskStatus.review:
        return "Review";
      case EnumTaskStatus.done:
        return "Done";
      case EnumTaskStatus.cancelled:
        return "Cancelled";
    }
  }

  static EnumTaskStatus fromText(String value) => EnumTaskStatus.values
      .firstWhere((e) => e.text == value, orElse: () => EnumTaskStatus.todo);
}
