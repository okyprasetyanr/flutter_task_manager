enum EnumWorkspace {
  workspaceId('workspace_id'),
  workspaceName('workspace_name'),
  workspaceDescription('workspace_description'),
  workspaceOwnerId('workspace_owner_id'),
  createdAt('created_at'),
  companyId('id_company');

  final String value;
  const EnumWorkspace(this.value);
}

enum EnumWorkspaceMember {
  workspaceId('workspace_id'),
  userId('user_id'),
  role('role');

  final String value;
  const EnumWorkspaceMember(this.value);
}

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

enum EnumProject {
  projectId('project_id'),
  projectName('project_name'),
  projectType('project_type'),
  projectStatus('project_status'),
  projectCreatedBy('project_created_by'),
  projectCreatedId('project_created_id'),
  projectTotalContribut('project_total_contribut'),
  projectStart('project_start'),
  projectEnd('project_end');

  final String value;
  const EnumProject(this.value);
}

enum EnumProjectMember {
  projectId('project_id'),
  userId('user_id'),
  role('role');

  final String value;
  const EnumProjectMember(this.value);
}

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
  createdAt('created_at');

  final String value;
  const EnumTask(this.value);
}

enum EnumSubTask {
  id('id'),
  taskId('task_id'),
  title('title'),
  isDone('is_done');

  final String value;
  const EnumSubTask(this.value);
}

enum EnumLabel {
  id('id'),
  name('name'),
  color('color');

  final String value;
  const EnumLabel(this.value);
}

enum EnumTaskLabel {
  taskId('task_id'),
  labelId('label_id');

  final String value;
  const EnumTaskLabel(this.value);
}

enum EnumComment {
  id('id'),
  taskId('task_id'),
  userId('user_id'),
  content('content'),
  createdAt('created_at');

  final String value;
  const EnumComment(this.value);
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

enum EnumActivity {
  id('id'),
  taskId('task_id'),
  userId('user_id'),
  action('action'),
  oldValue('old_value'),
  newValue('new_value'),
  createdAt('created_at');

  final String value;
  const EnumActivity(this.value);
}

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

enum EnumTaskHistory {
  id('id'),
  taskId('task_id'),
  field('field'),
  oldValue('old_value'),
  newValue('new_value'),
  changedBy('changed_by'),
  changedAt('changed_at');

  final String value;
  const EnumTaskHistory(this.value);
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

enum EnumTaskPriority {
  lowest('lowest'),
  low('low'),
  medium('medium'),
  high('high'),
  highest('highest');

  final String value;
  const EnumTaskPriority(this.value);
}

enum EnumCompany {
  companyName('company_name'),
  companyId('company_id'),
  companyJoin('company_join');

  final String value;
  const EnumCompany(this.value);
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
      EnumProjectStatus.values.firstWhere((element) => element.value == value);

  static String fromEnum(EnumProjectStatus value) {
    switch (value) {
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
        return "Tidak Diketahui!";
    }
  }

  static EnumProjectStatus fromText(String value) {
    switch (value) {
      case "Todo":
        return EnumProjectStatus.todo;
      case "On Progress":
        return EnumProjectStatus.onProgress;
      case "Review":
        return EnumProjectStatus.review;
      case "Completed":
        return EnumProjectStatus.completed;
      case "Cancelled":
        return EnumProjectStatus.cancelled;
      default:
        return EnumProjectStatus.unknown;
    }
  }
}

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
      EnumWorkspaceRole.values.firstWhere((element) => element.value == value);

  static String fromEnum(EnumWorkspaceRole value) {
    switch (value) {
      case EnumWorkspaceRole.owner:
        return "Pemilik";
      case EnumWorkspaceRole.admin:
        return "Admin";
      case EnumWorkspaceRole.member:
        return "Member";
      case EnumWorkspaceRole.guest:
        return "Guest";
    }
  }

  static EnumWorkspaceRole fromText(String value) {
    switch (value) {
      case "Pemilik":
        return EnumWorkspaceRole.owner;
      case "Admin":
        return EnumWorkspaceRole.admin;
      case "Member":
        return EnumWorkspaceRole.member;
      case "Guest":
        return EnumWorkspaceRole.guest;
      default:
        return EnumWorkspaceRole.guest;
    }
  }
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

enum EnumActivityAction {
  createTask('create_task'),
  updateTask('update_task'),
  deleteTask('delete_task'),
  assignTask('assign_task'),
  addComment('add_comment'),
  deleteComment('delete_comment'),
  addAttachment('add_attachment'),
  deleteAttachment('delete_attachment'),
  addLabel('add_label'),
  removeLabel('remove_label'),
  changeStatus('change_status'),
  changePriority('change_priority'),
  createSprint('create_sprint'),
  moveToSprint('move_to_sprint'),
  logWork('log_work');

  final String value;
  const EnumActivityAction(this.value);
}
