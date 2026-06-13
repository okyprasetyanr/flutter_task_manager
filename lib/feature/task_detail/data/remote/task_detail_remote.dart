// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/remote_service/remote_service.dart';

class TaskDetailRemote {
  final RemoteService apiServices;
  TaskDetailRemote({required this.apiServices});

  Future<Map<String, dynamic>> getComment({
    required String companyId,
    required String taskId,
  }) async {
    return await apiServices.getComments(companyId, taskId);
  }
}
