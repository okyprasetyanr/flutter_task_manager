import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';

class ActivityRemote {
  final ResponseWrapper responseWrapper;

  ActivityRemote({required this.responseWrapper});
  Future<Map<String, dynamic>> getActivity({
    required String workspaceId,
    required String companyId,
  }) async {
    return responseWrapper.wrap(getData: () async => {});
  }
}
