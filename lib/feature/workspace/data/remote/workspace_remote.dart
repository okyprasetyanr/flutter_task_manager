// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/remote_service/remote_service.dart';

class WorkspaceRemote {
  final RemoteService apiServices;

  WorkspaceRemote({required this.apiServices});

  Future<Map<String, dynamic>> getWorkspace({required String companyId}) async {
    return await apiServices.getWorkSpace(companyId);
  }
}
