// ignore_for_file: public_member_api_docs, sort_constructors_first, collection_methods_unrelated_type
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_manager/core/services/collector/collector_data_remote.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/stream_manager/stream_manager.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/login/data/local/login_local.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';

class LoginRepositoryImp implements LoginRepository {
  final CollectDataRemote helper;
  final RemoteService remote;
  final LoginLocal local;
  final UserSession userSession;
  final UserRepository userRepository;
  final StreamManager streamManager;

  LoginRepositoryImp({
    required this.helper,
    required this.remote,
    required this.local,
    required this.userSession,
    required this.userRepository,
    required this.streamManager,
  });

  @override
  Future<Map<EnumFetchApiStatus, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await helper.helperCollectData(
      remoteFunc: () async =>
          await remote.loginRemote.login(email: email, password: password),
      localFunc: ({dataToCache}) async => {},
    );
    if (data.containsKey(EnumFetchApiStatus.success)) {
      final pref = await SharedPreferences.getInstance();
      await pref.setString(
        EnumCompany.companyId.value,
        data[EnumFetchApiStatus.success][EnumCompany.companyId.value],
      );
      await pref.setString(
        EnumCompany.companyName.value,
        data[EnumFetchApiStatus.success][EnumCompany.companyName.value],
      );
      await pref.setString(
        EnumCompany.userId.value,
        data[EnumFetchApiStatus.success][EnumCompany.userId.value],
      );
      await userSession.init();
      userRepository.watchUser();
    }
    return data;
  }
}
