import 'package:task_manager/feature/login/domain/enum/enum.dart';

abstract class LoginRepository {
  Future<Map<EnumLoginStatus, dynamic>> login({
    required String email,
    required String password,
  });
}
