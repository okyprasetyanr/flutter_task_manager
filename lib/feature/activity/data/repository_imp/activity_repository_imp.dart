import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/activity/data/local/activity_local.dart';
import 'package:task_manager/feature/activity/domain/repository/activity_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

class ActivityRepositoryImp implements ActivityRepository {
  final RemoteServices remote;
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
    final data = await helper.collectDataRemote(
      remoteFunc: () => remote.activityRemote.getActivity(
        workspaceId: workspaceId,
        companyId: userSession.getCompanyId(),
      ),
      localFunc: ({required dataToCache}) async => {},
    );
    return (data, messageCollector.getMessage(data));
  }
}
