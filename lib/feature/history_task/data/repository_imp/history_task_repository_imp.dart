import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/history_task/data/local/history_task_local.dart';
import 'package:task_manager/feature/history_task/data/remote/history_task_remote.dart';
import 'package:task_manager/feature/history_task/domain/repository/history_task_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';
import 'package:task_manager/shared/model/model_user.dart';

class HistoryTaskRepositoryImp implements HistoryTaskRepository {
  final HistoryTaskRemote remote;
  final HistoryTaskLocal local;
  final UserSession userSession;
  final HelperCollectData helper;
  final ModelMessageCollector messageCollector;
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
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getHistoryTask() async {
    final data = await helper.helperCollectData(
      remoteFunc: () async =>
          await remote.getHistoryTask(companyId: userSession.getCompanyId()),
      localFunc: () async => {},
    );
    devLog("Log ProjectDetailRepositoryImp: data: $data");
    return (data, messageCollector.getMessage(data));
  }

  @override
  List<ModelUser> getUser() {
    return userCache.getUser();
  }
}
