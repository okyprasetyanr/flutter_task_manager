enum EnumComment {
  id('id'),
  taskId('task_id'),
  userId('user_id'),
  content('content'),
  createdAt('created_at'),
  updatedAt('updated_at');

  final String value;
  const EnumComment(this.value);
}
