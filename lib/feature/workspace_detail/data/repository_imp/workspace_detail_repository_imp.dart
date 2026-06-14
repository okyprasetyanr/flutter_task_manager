// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/workspace_detail/data/local/workspace_detail_local.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/model/model_user.dart';

class WorkspaceDetailRepositoryImp implements WorkspaceDetailRepository {
  final RemoteService remote;
  final WorkspaceDetailLocal local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserCache userCache;

  WorkspaceDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userCache,
  });

  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  getWorkspaceDetai({
    required String workspaceId,
    required String companyId,
  }) async {
    await fetchUser();

    final data = await helper.helperCollectData(
      remoteFunc: () async => await remote.workspaceDetailRemote
          .getWorkspaceDetail(workspaceId: workspaceId, companyId: companyId),
      localFunc: () async => {},
    );

    return (data, messageCollector.getMessage(data));
  }

  Future<void> fetchUser() async {
    final data = await helper.helperCollectData(
      remoteFunc: () async => await remote.workspaceDetailRemote.getUser(
        companyId: userSession.getCompanyId(),
      ),
      localFunc: () async => {},
    );

    if (data.containsKey(EnumFetchApiStatus.success)) {
      userCache.setUser(
        (data[EnumFetchApiStatus.success] as List)
            .map((e) => ModelUser.fromJson(e))
            .toList(),
      );
    }
  }

  @override
  List<ModelUser> getUser() {
    return userCache.getUser();
  }
}
