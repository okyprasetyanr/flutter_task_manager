// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class LoginRemote {
  final RemoteService apiService;
  LoginRemote({required this.apiService});

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await apiService.getLogin();
    devLog("Log LoginRemote: data: $data");
    return data;
  }
}
