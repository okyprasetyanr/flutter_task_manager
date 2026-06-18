import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';

class HistoryTaskRemote {
  final ResponseWrapperRemote responseWrapper;

  HistoryTaskRemote({required this.responseWrapper});

  Future<Map<String, dynamic>> getHistoryTask({
    required String companyId,
    required String workspaceId,
  }) async {
    return responseWrapper.wrap(getData: () async => {});
  }
}
