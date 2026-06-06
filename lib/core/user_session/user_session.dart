import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  String? companyId;
  String? nameCompany;
  void init() async {
    final pref = await SharedPreferences.getInstance();
    companyId = pref.getString("companyId") ?? "demo1";
    nameCompany = pref.getString("companyName") ?? "Demmo";
  }

  String getCompanyId() {
    return companyId!;
  }

  String getCompanyName() {
    return nameCompany!;
  }
}
