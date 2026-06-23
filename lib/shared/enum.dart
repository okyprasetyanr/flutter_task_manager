enum EnumSprint {
  sprintId('sprint_id'),
  projectId('project_id'),
  sprintName('sprint_name'),
  sprintGoal('sprint_goal'),
  startDate('start_date'),
  endDate('end_date'),
  isActive('is_active');

  final String value;
  const EnumSprint(this.value);
}

enum EnumAttachment {
  id('id'),
  taskId('task_id'),
  fileName('file_name'),
  fileUrl('file_url'),
  fileSize('file_size'),
  uploadedBy('uploaded_by'),
  uploadedAt('uploaded_at');

  final String value;
  const EnumAttachment(this.value);
}

enum EnumProjectRole {
  projectManager('project_manager'),
  backendDeveloper('backend_developer'),
  frontendDeveloper('frontend_developer'),
  flutterDeveloper('flutter_developer'),
  mobileDeveloper('mobile_developer'),
  uiUxDesigner('ui_ux_designer'),
  qaEngineer('qa_engineer'),
  devOps('dev_ops'),
  productOwner('product_owner');

  final String value;
  const EnumProjectRole(this.value);
}

extension EnumProjectRoleX on EnumProjectRole {
  static EnumProjectRole fromServer(String value) =>
      EnumProjectRole.values.firstWhere(
        (e) => e.value == value,
        orElse: () => EnumProjectRole.mobileDeveloper,
      );

  String get text {
    switch (this) {
      case EnumProjectRole.projectManager:
        return "Project Manager";
      case EnumProjectRole.backendDeveloper:
        return "Backend Developer";
      case EnumProjectRole.frontendDeveloper:
        return "Frontend Developer";
      case EnumProjectRole.flutterDeveloper:
        return "Flutter Developer";
      case EnumProjectRole.mobileDeveloper:
        return "Mobile Developer";
      case EnumProjectRole.uiUxDesigner:
        return "UI/UX Designer";
      case EnumProjectRole.qaEngineer:
        return "QA Engineer";
      case EnumProjectRole.devOps:
        return "DevOps Engineer";
      case EnumProjectRole.productOwner:
        return "Product Owner";
    }
  }

  static EnumProjectRole fromText(String value) =>
      EnumProjectRole.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumProjectRole.mobileDeveloper,
      );
}
