import 'package:task_manager/core/dummy/dummy_data.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';
import 'package:task_manager/shared/enum.dart';

class RemoteService {
  final ResponseWrapper responseWrapper;

  RemoteService({required this.responseWrapper});

  Future<Map<String, dynamic>> getProject(
    String workspaceId,
    String companyId,
  ) async {
    return responseWrapper.wrap(
      getData: () async => (await DummyData.project as List)
          .where(
            (element) => element[EnumProject.workspaceId.value] == workspaceId,
          )
          .toList(),
    );
  }

  Future<Map<String, dynamic>> getUser(String companyId) async {
    return responseWrapper.wrap(getData: () async => await DummyData.user);
  }

  Future<Map<String, dynamic>> getProjectMember(
    String projectId,
    String companyId,
  ) async {
    return responseWrapper.wrap(
      getData: () async => await DummyData.projectMember,
    );
  }

  Future<Map<String, dynamic>> getTasks(
    String companyId,
    String projectId,
  ) async {
    return responseWrapper.wrap(getData: () async => await DummyData.task);
  }

  Future<Map<String, dynamic>> getSubTasks(
    String companyId,
    String idTasks,
  ) async {
    return responseWrapper.wrap(getData: () async => await DummyData.subTask);
  }

  Future<Map<String, dynamic>> getLabel(String companyId) async {
    return responseWrapper.wrap(getData: () async => await DummyData.label);
  }

  Future<Map<String, dynamic>> getComments(
    String companyId,
    String idTask,
  ) async {
    return responseWrapper.wrap(
      getData: () async => (await DummyData.comment as List)
          .where((e) => e[EnumComment.taskId.value] == idTask)
          .toList(),
    );
  }

  Future<Map<String, dynamic>> getAttachment(
    String companyId,
    String idTask,
  ) async {
    return responseWrapper.wrap(
      getData: () async => await DummyData.attachment,
    );
  }

  Future<Map<String, dynamic>> getActivities({
    required String companyId,
    required String workspaceId,
  }) async {
    return responseWrapper.wrap(getData: () async => await DummyData.activity);
  }

  Future<Map<String, dynamic>> getWorkSpace(String companyId) async {
    return responseWrapper.wrap(getData: () async => await DummyData.workspace);
  }

  Future<Map<String, dynamic>> getWorkspaceMember(
    String workspaceId,
    String companyId,
  ) async {
    return responseWrapper.wrap(
      getData: () async => (await DummyData.workspaceMember as List)
          .where(
            (element) =>
                element[EnumWorkspaceMember.workspaceId.value] == workspaceId,
          )
          .toList(),
    );
  }

  Future<Map<String, dynamic>> getSprint(String projectId) async {
    return responseWrapper.wrap(getData: () async => (DummyData.sprint));
  }

  Future<Map<String, dynamic>> getNotification(String userId) async {
    return responseWrapper.wrap(
      getData: () async => (await DummyData.notification as List)
          .where((element) => element[EnumNotification.userId.value] == userId)
          .toList(),
    );
  }

  Future<Map<String, dynamic>> getTaskHistory({
    required String workspaceId,
  }) async {
    return responseWrapper.wrap(
      getData: () async => (await DummyData.taskHistory as List)
          .where(
            (element) =>
                element[EnumHistoryTask.workspaceId.value] == workspaceId,
          )
          .toList(),
    );
  }

  Future<Map<String, dynamic>> getLogin() async {
    return responseWrapper.wrap(
      getData: () async => await DummyData.loginSuccess,
    );
  }
}
