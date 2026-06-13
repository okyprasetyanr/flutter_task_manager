import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/activity/data/local/activity_local.dart';
import 'package:task_manager/feature/activity/data/remote/activity_remote.dart';
import 'package:task_manager/feature/activity/domain/repository/activity_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/model/model_user.dart';

class ActivityRepositoryImp implements ActivityRepository {
  final ActivityRemote remote;
  final ActivityLocal local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserCache userCache;

  ActivityRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userCache,
  });

  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getActivity({
    required String workspaceId,
  }) async {
    final data = await helper.helperCollectData(
      remoteFunc: () => remote.getActivity(
        workspaceId: workspaceId,
        companyId: userSession.getCompanyId(),
      ),
      localFunc: () async => {},
    );
    return (data, messageCollector.getMessage(data));
  }

  @override
  List<ModelUser> getUser() {
    return userCache.getUser();
  }
}
