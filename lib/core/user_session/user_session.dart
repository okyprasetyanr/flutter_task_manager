import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/shared/enum.dart';

class UserSession {
  String? companyId;
  String? nameCompany;
  String? userId;
  void init() async {
    final pref = await SharedPreferences.getInstance();
    companyId = pref.getString(EnumCompany.companyId.value) ?? "demo1";
    nameCompany = pref.getString(EnumCompany.companyName.value) ?? "Demmo";
    userId = pref.getString(EnumCompany.userId.value) ?? "USR002";
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
