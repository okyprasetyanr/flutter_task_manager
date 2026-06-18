import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';

class ActivityRemote {
  final ResponseWrapperRemote responseWrapper;

  ActivityRemote({required this.responseWrapper});
  Future<Map<String, dynamic>> getActivity({
    required String workspaceId,
    required String companyId,
  }) async {
    return responseWrapper.wrap(getData: () async => {});
  }
}
