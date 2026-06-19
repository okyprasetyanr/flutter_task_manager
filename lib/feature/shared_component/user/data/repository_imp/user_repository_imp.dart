// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/stream_manager/stream_manager.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar_root.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class UserRepositoryImp implements UserRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserCache userCache;
  final StreamManager streamSubsc;

  StreamSubscription? _sub;

  UserRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userCache,
    required this.streamSubsc,
  });

  @override
  void watchUser() {
    _sub?.cancel();

    remote.userRemote.watchUser(companyId: userSession.getCompanyId()).listen((
      event,
    ) async {
      final data = await helper.collectDataRemote(
        remoteFunc: () async => event,
        localFunc: ({required dataToCache}) async {
          local.userLocal.saveWorkspaces(dataToCache as List);
        },
        pageName: "User",
      );

      if (!data.containsKey(EnumFetchApiStatus.success)) {
        devLog("Log UserRepositoryImp: watchUser: data: $data");
        customRootSnackBar(messageCollector.getMessage(data));
      }
    });

    _sub = local.userLocal
        .watchUsers(companyId: userSession.getCompanyId())
        .listen((event) {
          final data = helper.collectDataLocal(fetchResult: event);

          if (data.containsKey(EnumFetchApiStatus.success)) {
            final users = (data[EnumFetchApiStatus.success] as List)
                .map((e) => ModelUser.fromDrift(e))
                .toSet();
            userCache.setUsers(users);
          } else {
            customRootSnackBar(messageCollector.getMessage(data));
          }
        });

    streamSubsc.addStreamSubsc(EnumTable.users, _sub!);
  }

  @override
  Stream<Set<ModelUser>> getUser() {
    return userCache.stream;
  }
}
