enum EnumWorkspaceRole {
  owner('owner'),
  admin('admin'),
  member('member'),
  guest('guest');

  final String value;
  const EnumWorkspaceRole(this.value);
}

extension EnumWorkspaceRoleX on EnumWorkspaceRole {
  static EnumWorkspaceRole fromServer(String value) =>
      EnumWorkspaceRole.values.firstWhere(
        (e) => e.value == value,
        orElse: () => EnumWorkspaceRole.guest,
      );

  String get text {
    switch (this) {
      case EnumWorkspaceRole.owner:
        return "Owner";
      case EnumWorkspaceRole.admin:
        return "Admin";
      case EnumWorkspaceRole.member:
        return "Member";
      case EnumWorkspaceRole.guest:
        return "Guest";
    }
  }

  static EnumWorkspaceRole fromText(String value) =>
      EnumWorkspaceRole.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumWorkspaceRole.guest,
      );
}

enum EnumWorkspace {
  id('id'),
  name('name'),
  description('description'),
  ownerId('owner_id'),
  createdAt('created_at'),
  companyId('company_id');

  final String value;
  const EnumWorkspace(this.value);
}

enum EnumWorkspaceMember {
  workspaceId('workspace_id'),
  companyId('company_id'),
  userId('user_id'),
  role('role'),
  id('id');

  final String value;
  const EnumWorkspaceMember(this.value);
}
