// ignore_for_file: constant_identifier_names

enum EnumWorkspace {
  workspaceId,
  workspaceName,
  workspaceDescription,
  workspaceOwnerId,
  createdAt,
  id_company,
}

enum EnumWorkspaceMember { workspaceId, userId, role }

enum EnumUser { id, name, email, photoUrl, createdAt, id_company }

enum EnumProject {
  projectId,
  workspaceId,
  projectName,
  projectType,
  projectStatus,
  projectCreatedBy,
  projectCreatedId,
  projectTotalContribut,
  projectStart,
  projectEnd,
}

enum EnumProjectMember { projectId, userId, role }

enum EnumSprint {
  sprintId,
  projectId,
  sprintName,
  sprintGoal,
  startDate,
  endDate,
  isActive,
}

enum EnumTask {
  id,
  projectId,
  sprintId,
  title,
  description,
  status,
  priority,
  storyPoint,
  reporterId,
  assigneeId,
  startDate,
  dueDate,
  createdAt,
}

enum EnumSubTask { id, taskId, title, isDone }

enum EnumLabel { id, name, color }

enum EnumTaskLabel { taskId, labelId }

enum EnumComment { id, taskId, userId, content, createdAt }

enum EnumAttachment {
  id,
  taskId,
  fileName,
  fileUrl,
  fileSize,
  uploadedBy,
  uploadedAt,
}

enum EnumActivity { id, taskId, userId, action, oldValue, newValue, createdAt }

enum EnumNotification { id, userId, title, body, isRead, createdAt }

enum EnumTaskHistory {
  id,
  taskId,
  field,
  oldValue,
  newValue,
  changedBy,
  changedAt,
}

enum EnumTaskStatus { todo, inProgress, review, done, cancelled }

extension EnumTaskStatusExt on EnumTaskStatus {
  String get value {
    switch (this) {
      case EnumTaskStatus.todo:
        return 'todo';
      case EnumTaskStatus.inProgress:
        return 'in_progress';
      case EnumTaskStatus.review:
        return 'review';
      case EnumTaskStatus.done:
        return 'done';
      case EnumTaskStatus.cancelled:
        return 'cancelled';
    }
  }
}

enum EnumTaskPriority { lowest, low, medium, high, highest }

enum EnumCompany { company_name, company_id, company_join }

enum EnumProjectStatus { todo, onProgress, review, completed, cancelled }

enum EnumWorkspaceRole { owner, admin, member, guest }

enum EnumProjectRole {
  projectManager,
  backendDeveloper,
  frontendDeveloper,
  flutterDeveloper,
  mobileDeveloper,
  uiUxDesigner,
  qaEngineer,
  devOps,
  productOwner,
}

enum EnumActivityAction {
  createTask,
  updateTask,
  deleteTask,
  assignTask,
  addComment,
  deleteComment,
  addAttachment,
  deleteAttachment,
  addLabel,
  removeLabel,
  changeStatus,
  changePriority,
  createSprint,
  moveToSprint,
  logWork,
}
