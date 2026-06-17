// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class UserRepositoryImp implements UserRepository {
  final RemoteService remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserCache userCache;
  final StreamManager streamSubsc;

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
    final stream = remote.userRemote
        .watchUser(companyId: userSession.getCompanyId())
        .listen((event) async {
          final data = await helper.helperCollectData(
            remoteFunc: () => event,
            localFunc: () => {},
          );
          if (data.containsKey(EnumFetchApiStatus.success)) {
            userCache.setUser(
              (data[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelUser.fromJson(e))
                  .toSet(),
            );
          } else {
            customRootSnackBar(messageCollector.getMessage(data));
          }
        });
    streamSubsc.addStreamSubsc(EnumTable.users, stream);
  }
}
