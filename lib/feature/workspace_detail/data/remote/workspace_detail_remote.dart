import 'package:task_manager/core/dummy/dummy_data.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';

class WorkspaceDetailRemote {
  final ResponseWrapper responseWrapper;

  WorkspaceDetailRemote({required this.responseWrapper});

  Future<Map<String, dynamic>> getWorkspaceDetail({
    required String workspaceId,
    required String companyId,
  }) async {
    return responseWrapper.wrap(getData: () async => {});
  }

  Future<Map<String, dynamic>> getUser({required String companyId}) {
    return responseWrapper.wrap(getData: () async => DummyData.user);
  }
}
