// ignore_for_file: public_member_api_docs, sort_constructors_first, collection_methods_unrelated_type
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/login/data/local/login_local.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/repository/not_log_repository.dart';
import 'package:task_manager/feature/shared_component/user/domain/enum/enum.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class LoginRepositoryImp implements LoginRepository {
  final CollectData helper;
  final RemoteServices remote;
  final LoginLocal local;
  final UserSession userSession;
  final UserRepository userRepository;
  final NotLogRepository notLogRepository;

  LoginRepositoryImp({
    required this.helper,
    required this.remote,
    required this.local,
    required this.userSession,
    required this.userRepository,
    required this.notLogRepository,
  });

  @override
  Future<Map<EnumFetchApiStatus, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final dataAccount = await helper.collectDataRemote(
      remoteFunc: () async =>
          await remote.loginRemote.login(email: email, password: password),
      localFunc: ({required dataToCache}) async => {},
      pageName: "Login",
    );
    devLog("Log LoginRepositoryImp: dataAccount: $dataAccount");
    final dataCompany = await helper.collectDataRemote(
      remoteFunc: () async => await remote.loginRemote.getCompany(
        companyId:
            dataAccount[EnumFetchApiStatus.success][EnumUser.companyId.value],
      ),
      localFunc: ({required dataToCache}) async => {},
      pageName: "Company",
    );
    if (dataAccount.containsKey(EnumFetchApiStatus.success) &&
        dataCompany.containsKey(EnumFetchApiStatus.success)) {
      final pref = await SharedPreferences.getInstance();
      await pref.setString(
        EnumTable.companies.value,
        jsonEncode(dataCompany[EnumFetchApiStatus.success]),
      );
      await pref.setString(
        EnumTable.users.value,
        jsonEncode(dataAccount[EnumFetchApiStatus.success]),
      );
      await userSession.init();
      userRepository.watchUser();
      notLogRepository.watchNotification();
    }
    return dataAccount;
  }
}
