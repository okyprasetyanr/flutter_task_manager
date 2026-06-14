import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';

class NotificationRemote {
  final ResponseWrapper responseWrapper;

  NotificationRemote({required this.responseWrapper});

  Future<Map<String, dynamic>> getNotification({required String userId}) async {
    return responseWrapper.wrap(getData: () async => {});
  }
}
