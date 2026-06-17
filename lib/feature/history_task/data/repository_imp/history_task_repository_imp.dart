import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/history_task/data/local/history_task_local.dart';
import 'package:task_manager/feature/history_task/domain/repository/history_task_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class HistoryTaskRepositoryImp implements HistoryTaskRepository {
  final RemoteService remote;
  final HistoryTaskLocal local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserCache userCache;

  HistoryTaskRepositoryImp({
    required this.remote,
    required this.userCache,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });
  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getHistoryTask({
    required String workspaceId,
  }) async {
    final data = await helper.helperCollectData(
      remoteFunc: () async => await remote.historyTaskRemote.getHistoryTask(
        companyId: userSession.getCompanyId(),
        workspaceId: workspaceId,
      ),
      localFunc: () async => {},
    );
    devLog("Log ProjectDetailRepositoryImp: data: $data");
    return (data, messageCollector.getMessage(data));
  }

  @override
  Set<ModelUser> getUser() {
    return userCache.getUser();
  }
}
