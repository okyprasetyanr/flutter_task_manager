import 'package:task_manager/feature/login/domain/enum/enum.dart';

class LoginSaveAccount {
  final Map<EnumLoginStatus, dynamic> data;

  LoginSaveAccount({required this.data});

  Future<bool> save() async {
    return true;
  }
}
