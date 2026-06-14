// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';

class TaskDetailRemote {
  final ResponseWrapper responseWrapper;
  TaskDetailRemote({required this.responseWrapper});

  Future<Map<String, dynamic>> getComment({
    required String companyId,
    required String taskId,
  }) async {
    return responseWrapper.wrap(getData: () async => {});
  }
}
