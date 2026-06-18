// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/services/collector/collector_data_remote.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/stream_manager/stream_manager.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceRepositoryImp implements WorkspaceRepository {
  final RemoteService remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectDataRemote helperRemote;
  final CollectorMessage messageCollector;
  final StreamManager streamManager;
  final UserCache userCache;

  WorkspaceRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helperRemote,
    required this.messageCollector,
    required this.streamManager,
    required this.userCache,
  });

  @override
  String getCompanyName() {
    return userSession.getCompanyName();
  }

  @override
  Stream<Map<String, dynamic>> watchWorkspace() {
    final companyId = userSession.getCompanyId();
    return local.workspaceLocal.watchLocalWorkspace(companyId);
  }

  @override
  Stream<CollectorMessage> watchWorkspaceMessage() {
    final companyId = userSession.getCompanyId();

    return watchAndCacheRemoteWorkspace(
      companyId,
    ).map(messageCollector.getMessage);
  }

  Stream<Map<EnumFetchApiStatus, dynamic>> watchAndCacheRemoteWorkspace(
    String companyId,
  ) {
    return remote.workspaceRemote.watchWorkspaces(companyId: companyId).asyncMap((
      remoteEvent,
    ) async {
      return await helperRemote.helperCollectData(
        remoteFunc: () async => remoteEvent,
        localFunc: ({dataToCache}) async {
          if (dataToCache != null) {
            final listWorkspace = List<Map<String, dynamic>>.from(dataToCache);

            devLog(
              "Log WorkspaceLocal: saveWorkspace: listWorkspace: $listWorkspace",
            );
            await local.workspaceLocal.saveWorkspacesToLocal(listWorkspace);
          }
        },
      );
    });
  }

  @override
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchWorkspaceMember() {
    return remote.workspaceRemote
        .watchWorkspaceMembers(companyId: userSession.getCompanyId())
        .asyncMap((rawMapFromRemote) async {
          final Map<EnumFetchApiStatus, dynamic> data = await helperRemote
              .helperCollectData(
                remoteFunc: () async => rawMapFromRemote,
                localFunc: ({dataToCache}) async => {},
              );
          final collectorMessage = messageCollector.getMessage(data);
          devLog("Log WorkspaceRepositoryImp: data: $data");
          return (data, collectorMessage);
        });
  }

  @override
  Future<CollectorMessage?> createWorkspace({
    required String name,
    required String description,
  }) async {
    final data = ModelWorkspace.createWorkspace(
      name: name,
      description: description,
      companyId: userSession.getCompanyId(),
      userId: userSession.getUserId(),
    );
    final response = await helperRemote.helperCollectData(
      remoteFunc: () async =>
          await remote.workspaceRemote.createWorkspace(data.toJson()),
      localFunc: ({dataToCache}) async => {},
    );
    return response.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(response);
  }

  @override
  Future<CollectorMessage?> deleteWorkspace({
    required String workspaceId,
  }) async {
    final response = await helperRemote.helperCollectData(
      remoteFunc: () async =>
          await remote.workspaceRemote.deleteWorkspace(workspaceId),
      localFunc: ({dataToCache}) async => {},
    );
    return response.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(response);
  }

  @override
  Future<CollectorMessage?> updateWorkspace({
    required ModelWorkspace original,
    required ModelWorkspace edited,
  }) async {
    final finalUpdated = ModelWorkspace.workspaceGetChangedData(
      original: original.toJson(),
      edited: edited.toJson(),
    );
    final response = await helperRemote.helperCollectData(
      remoteFunc: () async =>
          await remote.workspaceRemote.updateWorkspace(finalUpdated),
      localFunc: ({dataToCache}) async => {},
    );
    return response.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(response);
  }

  @override
  Set<ModelUser> getUser() {
    return userCache.getUser();
  }
}
