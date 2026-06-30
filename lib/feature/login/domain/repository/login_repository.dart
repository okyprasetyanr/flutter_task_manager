import 'package:task_manager/shared/enum/enum_fetch_api.dart';

abstract class LoginRepository {
  Future<Map<EnumFetchApiStatus, dynamic>> login({
    required String email,
    required String password,
  });
  Future<bool> autoLogin();
}
