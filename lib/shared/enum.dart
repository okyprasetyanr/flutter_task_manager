import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/activity/domain/model/model_activity.dart';
import 'package:task_manager/shared/model/model_display_history.dart';
import 'package:task_manager/feature/history_task/domain/model/model_task_history.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

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
  labelIds('label_ids'),
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

enum EnumSubTask {
  id('id'),
  taskId('task_id'),
  title('title'),
  isDone('is_done'),
  projectId('project_id');

  final String value;
  const EnumSubTask(this.value);
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
  createdAt('created_at'),
  workspaceId('workspace_id');

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

enum EnumHistoryTask {
  id('id'),
  taskId('task_id'),
  field('field'),
  oldValue('old_value'),
  newValue('new_value'),
  changedBy('changed_by'),
  changedAt('changed_at'),
  workspaceId('workspace_id');

  final String value;
  const EnumHistoryTask(this.value);
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

enum EnumCompany {
  companyName('company_name'),
  companyId('company_id'),
  companyJoin('company_join'),
  userId('user_id');

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

enum EnumHistoryField {
  status,
  priority,
  assigneeId,
  storyPoint,
  dueDate;

  String get text {
    switch (this) {
      case EnumHistoryField.status:
        return 'Status';

      case EnumHistoryField.priority:
        return 'Priority';

      case EnumHistoryField.assigneeId:
        return 'AssigneeId';

      case EnumHistoryField.storyPoint:
        return 'Story Point';

      case EnumHistoryField.dueDate:
        return 'Due Date';
    }
  }

  static EnumHistoryField fromString(String value) {
    return EnumHistoryField.values.firstWhere((e) => e.text == value);
  }
}

extension ModelHistoryTaskX on ModelHistoryTask {
  OldNewDisplayValue display({required Set<ModelUser> users}) {
    switch (field) {
      case EnumHistoryField.assigneeId:
        return OldNewDisplayValue(
          oldValue:
              users.where((e) => e.id == oldValue).firstOrNull?.name ?? '-',
          newValue:
              users.where((e) => e.id == newValue).firstOrNull?.name ?? '-',
        );

      case EnumHistoryField.dueDate:
        return OldNewDisplayValue(
          oldValue: HelperDateConvert.toDisplayUI(
            date: HelperDateConvert.toDateTime(oldValue),
          ),
          newValue: HelperDateConvert.toDisplayUI(
            date: HelperDateConvert.toDateTime(newValue),
          ),
        );
      case EnumHistoryField.status:
        return OldNewDisplayValue(
          oldValue: EnumTaskStatusX.fromServer(oldValue).text,
          newValue: EnumTaskStatusX.fromServer(newValue).text,
        );

      case EnumHistoryField.priority:
        return OldNewDisplayValue(
          oldValue: EnumTaskPriorityX.fromServer(oldValue).text,
          newValue: EnumTaskPriorityX.fromServer(newValue).text,
        );
      default:
        return OldNewDisplayValue(oldValue: oldValue, newValue: newValue);
    }
  }
}

enum EnumActivityAction {
  createTask('create_task'),
  updateTask('update_task'),
  deleteTask('delete_task'),
  updateStatus('update_status'),
  updatePriority('update_priority'),
  assignUser('assign_user'),
  unassignUser('unassign_user'),
  addLabel('add_label'),
  removeLabel('remove_label'),
  addComment('add_comment'),
  editComment('edit_comment'),
  deleteComment('delete_comment'),
  addAttachment('add_attachment'),
  deleteAttachment('delete_attachment'),
  createSubtask('create_subtask'),
  updateSubtask('update_subtask'),
  completeSubtask('complete_subtask'),
  deleteSubtask('delete_subtask'),
  unknown('unknown');

  const EnumActivityAction(this.value);

  final String value;

  static EnumActivityAction fromValue(String value) {
    return EnumActivityAction.values.firstWhere((e) => e.value == value);
  }
}

extension EnumActivityActionX on EnumActivityAction {
  static EnumActivityAction fromServer(String value) =>
      EnumActivityAction.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumActivityAction.unknown,
      );

  String get text {
    switch (this) {
      case EnumActivityAction.createTask:
        return 'Create Task';

      case EnumActivityAction.updateTask:
        return 'Update Task';

      case EnumActivityAction.deleteTask:
        return 'Delete Task';

      case EnumActivityAction.updateStatus:
        return 'Update Status';

      case EnumActivityAction.updatePriority:
        return 'Update Priority';

      case EnumActivityAction.assignUser:
        return 'Assign User';

      case EnumActivityAction.unassignUser:
        return 'Unassign User';

      case EnumActivityAction.addLabel:
        return 'Add Label';

      case EnumActivityAction.removeLabel:
        return 'Remove Label';

      case EnumActivityAction.addComment:
        return 'Add Comment';

      case EnumActivityAction.editComment:
        return 'Edit Comment';

      case EnumActivityAction.deleteComment:
        return 'Delete Comment';

      case EnumActivityAction.addAttachment:
        return 'Add Attachment';

      case EnumActivityAction.deleteAttachment:
        return 'Delete Attachment';

      case EnumActivityAction.createSubtask:
        return 'Create Subtask';

      case EnumActivityAction.updateSubtask:
        return 'Update Subtask';

      case EnumActivityAction.completeSubtask:
        return 'Complete Subtask';

      case EnumActivityAction.deleteSubtask:
        return 'Delete Subtask';

      case EnumActivityAction.unknown:
        return 'Unknown!';
    }
  }

  static EnumActivityAction fromText(String value) =>
      EnumActivityAction.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumActivityAction.unknown,
      );
}

extension ModelActivityX on ModelActivity {
  OldNewDisplayValue display({required Set<ModelUser> users}) {
    switch (action) {
      case EnumActivityAction.createTask:
      case EnumActivityAction.deleteTask:
        return OldNewDisplayValue(
          oldValue: oldValue.isEmpty ? '-' : oldValue,
          newValue: newValue.isEmpty ? '-' : newValue,
        );

      case EnumActivityAction.updateStatus:
        return OldNewDisplayValue(
          oldValue: EnumTaskStatusX.fromServer(oldValue).text,
          newValue: EnumTaskStatusX.fromServer(newValue).text,
        );

      case EnumActivityAction.updatePriority:
        return OldNewDisplayValue(
          oldValue: EnumTaskPriorityX.fromServer(oldValue).text,
          newValue: EnumTaskPriorityX.fromServer(newValue).text,
        );

      case EnumActivityAction.assignUser:
        return OldNewDisplayValue(
          oldValue:
              users.where((e) => e.id == oldValue).firstOrNull?.name ?? '-',
          newValue:
              users.where((e) => e.id == newValue).firstOrNull?.name ?? '-',
        );

      case EnumActivityAction.unassignUser:
        return OldNewDisplayValue(
          oldValue:
              users.where((e) => e.id == oldValue).firstOrNull?.name ?? '-',
          newValue:
              users.where((e) => e.id == newValue).firstOrNull?.name ?? '-',
        );

      case EnumActivityAction.updateTask:
        final parsedOld = HelperDateConvert.toDateTime(oldValue);
        final parsedNew = HelperDateConvert.toDateTime(newValue);

        return OldNewDisplayValue(
          oldValue: oldValue.isNotEmpty
              ? HelperDateConvert.toDisplayUI(date: parsedOld)
              : '-',
          newValue: newValue.isNotEmpty
              ? HelperDateConvert.toDisplayUI(date: parsedNew)
              : '-',
        );

      case EnumActivityAction.addLabel:
      case EnumActivityAction.removeLabel:
      case EnumActivityAction.addComment:
      case EnumActivityAction.editComment:
      case EnumActivityAction.deleteComment:
      case EnumActivityAction.addAttachment:
      case EnumActivityAction.deleteAttachment:
      case EnumActivityAction.createSubtask:
      case EnumActivityAction.updateSubtask:
      case EnumActivityAction.completeSubtask:
      case EnumActivityAction.deleteSubtask:
        return OldNewDisplayValue(
          oldValue: oldValue.isEmpty ? '-' : oldValue,
          newValue: newValue.isEmpty ? '-' : newValue,
        );

      case EnumActivityAction.unknown:
        return OldNewDisplayValue(oldValue: oldValue, newValue: newValue);
    }
  }
}

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
