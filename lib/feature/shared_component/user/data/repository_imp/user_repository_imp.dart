// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/stream_manager/stream_manager.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/user/domain/enum/enum.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar_root.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class UserRepositoryImp
    with StreamSubscriptionManager
    implements UserRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserCache userCache;

  UserRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userCache,
  });

  RealtimeChannel? _userChannel;

  @override
  Future<void> watchUser() async {
    await initUserRealtime();

    addStreamSubscription(
      EnumTable.users,
      local.userLocal.watchUser(companyId: userSession.getCompanyId()).listen((
        event,
      ) {
        final data = helper.collectDataLocal(fetchResult: event);

        devLog("Log UserRepositoryImp: initData: $data");
        if (data.containsKey(EnumFetchApiStatus.success)) {
          final users = (data[EnumFetchApiStatus.success] as List)
              .map((e) => ModelUser.fromDrift(e))
              .toSet();
          userCache.setUsers(users);
        } else {
          customRootSnackBar(messageCollector.getMessage(data));
        }
      }),
    );
  }

  Future<void> initUserRealtime() async {
    final companyId = userSession.getCompanyId();
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote.userRemote
          .getAllUser(companyId: companyId);
      devLog("Log UserRepositoryImp: initData: $rawRemoteData");
      await local.userLocal.syncUser(remoteResults: rawRemoteData, init: true);
    } catch (e) {
      devLog("Log UserRepositoryImp: error: $e");
    }

    if (_userChannel != null) {
      remote.userRemote.removeUserChannel(_userChannel!);
      _userChannel = null;
    }
    _userChannel = remote.userRemote.buildUserChannel(companyId);

    _userChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.users.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumUser.companyId.value,
            value: companyId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.userLocal.deleteUser(deleteId.toString());
                }
              } else {
                final data = payload.newRecord;
                await local.userLocal.syncUser(remoteResults: [data]);
              }
            } catch (e) {
              devLog("Log UserRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log UserRepositoryImp: error Supabase: $error");
          }
        });
  }

  @override
  Stream<Set<ModelUser>> getUser() {
    devLog("Log UserRepository: getUser: check");
    return userCache.stream;
  }

  @override
  Future<void> disposeUserRealtime() async {
    clearStreamSubscriptions();
    if (_userChannel != null) {
      remote.userRemote.removeUserChannel(_userChannel!);
      _userChannel = null;
    }

    userCache.clear();
  }
}
