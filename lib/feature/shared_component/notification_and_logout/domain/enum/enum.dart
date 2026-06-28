enum EnumNotification {
  id('id'),
  userId('user_id'),
  title('title'),
  body('body'),
  isRead('is_read'),
  createdAt('created_at');

  final String value;
  const EnumNotification(this.value);
}
