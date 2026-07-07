import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/feature/login/domain/model/model_company.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class UserSession {
  ModelCompany? company;
  ModelUser? user;

  Future<bool> init() async {
    final pref = await SharedPreferences.getInstance();
    company = ModelCompany.fromJson(
      jsonDecode(pref.getString(EnumTable.companies.value) ?? ""),
    );
    user = ModelUser.fromJson(
      jsonDecode(pref.getString(EnumTable.users.value) ?? ""),
    );
    return true;
  }

  ModelCompany getCompany() {
    return company!;
  }

  ModelUser getUser() {
    return user!;
  }

  Future<void> clear() async {
    final pref = await SharedPreferences.getInstance();

    await pref.remove(EnumTable.users.value);
    await pref.remove(EnumTable.companies.value);

    company = null;
    user = null;
  }
}
