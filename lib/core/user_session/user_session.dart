import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/shared/enum.dart';

class UserSession {
  String? companyId;
  String? nameCompany;
  String? userId;

  Future<bool> init() async {
    final pref = await SharedPreferences.getInstance();
    companyId = pref.getString(EnumCompany.companyId.value) ?? "";
    nameCompany = pref.getString(EnumCompany.companyName.value) ?? "";
    userId = pref.getString(EnumCompany.userId.value) ?? "";
    return true;
  }

  String getCompanyId() {
    return companyId!;
  }

  String getCompanyName() {
    return nameCompany!;
  }

  String getUserId() {
    return userId!;
  }
}
