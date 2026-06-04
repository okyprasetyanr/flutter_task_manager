import 'package:task_manager/core/services/api_services.dart';

class LoginRemote {
  final ApiServices apiService;

  LoginRemote({required this.apiService});
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await apiService.getLogin();
    return data['result']!;
  }
}
