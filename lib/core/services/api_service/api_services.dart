import 'package:task_manager/core/dummy/dummy_data.dart';

class ApiServices {
  Future<Map<String, dynamic>> getProject(
    String idCompany,
    String uidOwner,
  ) async {
    return DummyData.project;
  }

  Future<Map<String, dynamic>> getUser(String uidOwner) async {
    return DummyData.user;
  }

  Future<Map<String, dynamic>> getProjectMember(
    String idProject,
    String uidOwner,
  ) async {
    return DummyData.projectMember;
  }

  Future<Map<String, dynamic>> getTasks(
    String uidOwner,
    String idProject,
  ) async {
    return DummyData.task;
  }

  Future<Map<String, dynamic>> getSubTasks(
    String uidOwner,
    String idTasks,
  ) async {
    return DummyData.subTask;
  }

  Future<Map<String, dynamic>> getLabel(String uidOwner) async {
    return DummyData.label;
  }

  Future<Map<String, dynamic>> getTasksLabel(String uidOwner) async {
    return DummyData.taskLabel;
  }

  Future<Map<String, dynamic>> getComments(
    String uidOwner,
    String idTask,
    String idUser,
  ) async {
    return DummyData.comment;
  }

  Future<Map<String, dynamic>> getAttachment(
    String uidOwner,
    String idTask,
  ) async {
    return DummyData.attachment;
  }

  Future<Map<String, dynamic>> getActivities(
    String uidOwner,
    String idTask,
    String idUser,
  ) async {
    return DummyData.activity;
  }

  Future<Map<String, dynamic>> getWorkSpace(String idCompany) async {
    return DummyData.workspace;
  }

  Future<Map<String, dynamic>> getWorkspaceMember(String idWorkspace) async {
    return DummyData.workspaceMember;
  }

  Future<Map<String, dynamic>> getSprint(String idProject) async {
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
