import 'package:task_manager/core/dummy/dummy_data.dart';

class ApiServices {
  Future<Map<String, dynamic>> getProject(
    String workspaceId,
    String companyId,
  ) async {
    return DummyData.project;
  }

  Future<Map<String, dynamic>> getUser(String companyId) async {
    return DummyData.user;
  }

  Future<Map<String, dynamic>> getProjectMember(
    String projectId,
    String companyId,
  ) async {
    return DummyData.projectMember;
  }

  Future<Map<String, dynamic>> getTasks(
    String companyId,
    String projectId,
  ) async {
    return DummyData.task;
  }

  Future<Map<String, dynamic>> getSubTasks(
    String companyId,
    String idTasks,
  ) async {
    return DummyData.subTask;
  }

  Future<Map<String, dynamic>> getLabel(String companyId) async {
    return DummyData.label;
  }

  Future<Map<String, dynamic>> getComments(
    String companyId,
    String idTask,
    String idUser,
  ) async {
    return DummyData.comment;
  }

  Future<Map<String, dynamic>> getAttachment(
    String companyId,
    String idTask,
  ) async {
    return DummyData.attachment;
  }

  Future<Map<String, dynamic>> getActivities(
    String companyId,
    String idTask,
    String idUser,
  ) async {
    return DummyData.activity;
  }

  Future<Map<String, dynamic>> getWorkSpace(String companyId) async {
    return DummyData.workspace;
  }

  Future<Map<String, dynamic>> getWorkspaceMember(
    String workspaceId,
    String companyId,
  ) async {
    return DummyData.workspaceMember;
  }

  Future<Map<String, dynamic>> getSprint(String projectId) async {
    return DummyData.sprint;
  }

  Future<Map<String, dynamic>> getNotification(String idUser) async {
    return DummyData.notification;
  }

  Future<Map<String, dynamic>> getTaskHistory() async {
    return DummyData.taskHistory;
  }

  Future<Map<String, dynamic>> getLogin() async {
    return DummyData.loginSuccess;
  }
}
