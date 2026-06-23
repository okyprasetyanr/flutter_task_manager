enum EnumProject {
  id('id'),
  name('name'),
  type('type'),
  status('status'),
  createdAt('created_at'),
  createdBy('created_by'),
  totalContribut('total_contribut'),
  start('start_date'),
  end('end_date'),
  workspaceId('workspace_id');

  final String value;
  const EnumProject(this.value);
}

enum EnumProjectMember {
  projectId('project_id'),
  workspaceId('workspace_id'),
  userId('user_id'),
  role('role'),
  id('id');

  final String value;
  const EnumProjectMember(this.value);
}

enum EnumProjectStatus {
  todo('todo'),
  onProgress('on_progress'),
  review('review'),
  completed('completed'),
  cancelled('cancelled'),
  unknown('unknown');

  final String value;
  const EnumProjectStatus(this.value);
}

extension EnumProjectStatusX on EnumProjectStatus {
  static EnumProjectStatus fromServer(String value) =>
      EnumProjectStatus.values.firstWhere(
        (e) => e.value == value,
        orElse: () => EnumProjectStatus.unknown,
      );

  String get text {
    switch (this) {
      case EnumProjectStatus.todo:
        return "Todo";
      case EnumProjectStatus.onProgress:
        return "On Progress";
      case EnumProjectStatus.review:
        return "Review";
      case EnumProjectStatus.completed:
        return "Completed";
      case EnumProjectStatus.cancelled:
        return "Cancelled";
      case EnumProjectStatus.unknown:
        return "Unknown!";
    }
  }

  static EnumProjectStatus fromText(String value) =>
      EnumProjectStatus.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumProjectStatus.unknown,
      );
}
