enum EnumUser {
  id('id'),
  name('name'),
  email('email'),
  photoUrl('photo_url'),
  createdAt('created_at'),
  companyId('company_id');

  final String value;
  const EnumUser(this.value);
}
