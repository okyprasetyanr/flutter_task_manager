// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/api_service/api_services.dart';

class WorkspaceRemote {
  final ApiServices apiServices;

  WorkspaceRemote({required this.apiServices});

  Future<Map<String, dynamic>> getWorkspace({required String idCompany}) async {
    return await apiServices.getWorkSpace(idCompany);
  }
}
