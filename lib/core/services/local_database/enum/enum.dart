enum EnumTable {
  activities('activities'),
  comments('comments'),
  companies('companies'),
  labels('labels'),
  notifications('notifications'),
  projectMembers('project_members'),
  projects('projects'),
  subtasks('subtasks'),
  taskHistories('task_histories'),
  taskLabels('task_labels'),
  tasks('tasks'),
  users('users'),
  workspaceMembers('workspace_members'),
  workspaces('workspaces');

  final String value;
  const EnumTable(this.value);
}
