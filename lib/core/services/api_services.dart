import 'package:task_manager/core/dummy/dummy_data.dart';

class ApiServices {
  Future<List<Map<String, dynamic>>> getProject(
    String idCompany,
    String uidOwner,
  ) async {
    return DummyData.project;
  }

  Future<List<Map<String, dynamic>>> getUser(String uidOwner) async {
    return DummyData.user;
  }

  Future<List<Map<String, dynamic>>> getProjectMember(
    String idProject,
    String uidOwner,
  ) async {
    return DummyData.projectMember;
  }

  Future<List<Map<String, dynamic>>> getTasks(
    String uidOwner,
    String idProject,
  ) async {
    return DummyData.task;
  }

  Future<List<Map<String, dynamic>>> getSubTasks(
    String uidOwner,
    String idTasks,
  ) async {
    return DummyData.subTask;
  }

  Future<List<Map<String, dynamic>>> getLabel(String uidOwner) async {
    return DummyData.label;
  }

  Future<List<Map<String, dynamic>>> getTasksLabel(String uidOwner) async {
    return DummyData.taskLabel;
  }

  Future<List<Map<String, dynamic>>> getComments(
    String uidOwner,
    String idTask,
    String idUser,
  ) async {
    return DummyData.comment;
  }

  Future<List<Map<String, dynamic>>> getAttachment(
    String uidOwner,
    String idTask,
  ) async {
    return DummyData.attachment;
  }

  Future<List<Map<String, dynamic>>> getActivities(
    String uidOwner,
    String idTask,
    String idUser,
  ) async {
    return DummyData.activity;
  }

  Future<List<Map<String, dynamic>>> getWorkSpace(String uidOwner) async {
    return DummyData.workspace;
  }

  Future<List<Map<String, dynamic>>> getWorkspaceMember(
    String idWorkspace,
  ) async {
    return DummyData.workspaceMember;
  }

  Future<List<Map<String, dynamic>>> getSprint(String idProject) async {
    return DummyData.sprint;
  }

  Future<List<Map<String, dynamic>>> getNotification(String idUser) async {
    return DummyData.notification;
  }

  Future<List<Map<String, dynamic>>> getTaskHistory() async {
    return DummyData.taskHistory;
  }

  Future<Map<String, dynamic>> getLogin() async {
    return DummyData.loginSuccess;
  }
}
