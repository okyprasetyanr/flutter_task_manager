import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';

class ProjectDetailRemote {
  final ResponseWrapper responseWrapper;

  ProjectDetailRemote({required this.responseWrapper});

  Future<Map<String, dynamic>> getProjectDetail({
    required String projectId,
    required String companyId,
  }) async {
    return responseWrapper.wrap(getData: () async => {});
  }
}
