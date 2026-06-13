import 'package:task_manager/core/dummy/dummy_data.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';
import 'package:task_manager/shared/enum.dart';

class ApiServices {
  Future<Map<String, dynamic>> getProject(
    String workspaceId,
    String companyId,
  ) async {
    return ResponseWrapper(
      getData: () async => (await DummyData.project as List)
          .where(
            (element) => element[EnumProject.workspaceId.value] == workspaceId,
          )
          .toList(),
    ).wrap();
  }

  Future<Map<String, dynamic>> getUser(String companyId) async {
    return ResponseWrapper(getData: () async => await DummyData.user).wrap();
  }

  Future<Map<String, dynamic>> getProjectMember(
    String projectId,
    String companyId,
  ) async {
    return ResponseWrapper(
      getData: () async => await DummyData.projectMember,
    ).wrap();
  }

  Future<Map<String, dynamic>> getTasks(
    String companyId,
    String projectId,
  ) async {
    return ResponseWrapper(getData: () async => await DummyData.task).wrap();
  }

  Future<Map<String, dynamic>> getSubTasks(
    String companyId,
    String idTasks,
  ) async {
    return ResponseWrapper(getData: () async => await DummyData.subTask).wrap();
  }

  Future<Map<String, dynamic>> getLabel(String companyId) async {
    return ResponseWrapper(getData: () async => await DummyData.label).wrap();
  }

  Future<Map<String, dynamic>> getComments(
    String companyId,
    String idTask,
  ) async {
    return ResponseWrapper(
      getData: () async => (await DummyData.comment as List)
          .where((e) => e[EnumComment.taskId.value] == idTask)
          .toList(),
    ).wrap();
  }

  Future<Map<String, dynamic>> getAttachment(
    String companyId,
    String idTask,
  ) async {
    return ResponseWrapper(
      getData: () async => await DummyData.attachment,
    ).wrap();
  }

  Future<Map<String, dynamic>> getActivities({
    required String companyId,
    required String workspaceId,
  }) async {
    return ResponseWrapper(
      getData: () async => await DummyData.activity,
    ).wrap();
  }

  Future<Map<String, dynamic>> getWorkSpace(String companyId) async {
    return ResponseWrapper(
      getData: () async => await DummyData.workspace,
    ).wrap();
  }

  Future<Map<String, dynamic>> getWorkspaceMember(
    String workspaceId,
    String companyId,
  ) async {
    return ResponseWrapper(
      getData: () async => (await DummyData.workspaceMember as List)
          .where(
            (element) =>
                element[EnumWorkspaceMember.workspaceId.value] == workspaceId,
          )
          .toList(),
    ).wrap();
  }

  Future<Map<String, dynamic>> getSprint(String projectId) async {
    return ResponseWrapper(getData: () async => (DummyData.sprint)).wrap();
  }

  Future<Map<String, dynamic>> getNotification(String userId) async {
    return ResponseWrapper(
      getData: () async => (await DummyData.notification as List)
          .where((element) => element[EnumNotification.userId.value] == userId)
          .toList(),
    ).wrap();
  }

  Future<Map<String, dynamic>> getTaskHistory({
    required String workspaceId,
  }) async {
    return ResponseWrapper(
      getData: () async => (await DummyData.taskHistory as List)
          .where(
            (element) =>
                element[EnumHistoryTask.workspaceId.value] == workspaceId,
          )
          .toList(),
    ).wrap();
  }

  Future<Map<String, dynamic>> getLogin() async {
    return ResponseWrapper(
      getData: () async => await DummyData.loginSuccess,
    ).wrap();
  }
}
