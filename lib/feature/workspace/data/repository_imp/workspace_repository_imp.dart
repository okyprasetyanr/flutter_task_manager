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
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceRepositoryImp implements WorkspaceRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final StreamManager streamManager;
  final UserCache userCache;

  WorkspaceRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.streamManager,
    required this.userCache,
  });

  @override
  String getCompanyName() {
    return userSession.getCompanyName();
  }

  @override
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchWorkspace() {
    return local.workspaceLocal
        .watchWorkspace(companyId: userSession.getCompanyId())
        .map((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          return (data, messageCollector.getMessage(data));
        });
  }

  @override
  Stream<CollectorMessage> messageWorkspace() {
    return remote.workspaceRemote
        .watchWorkspaces(companyId: userSession.getCompanyId())
        .asyncMap((event) async {
          final data = await helper.collectDataRemote(
            remoteFunc: () async => event,
            localFunc: ({required dataToCache}) async {
              if (dataToCache.containsKey(EnumFetchApiStatus.success)) {
                await local.workspaceLocal.saveWorkspaces(
                  dataToCache[EnumFetchApiStatus.success] as List,
                );
              }
            },
          );

          return messageCollector.getMessage(data);
        });
  }

  @override
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchMember() {
    return local.workspaceLocal
        .watchMember(companyId: userSession.getCompanyId())
        .map((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          final collectorMessage = messageCollector.getMessage(data);
          devLog("Log WorkspaceRepositoryImp: data: $data");
          return (data, collectorMessage);
        });
  }

  @override
  Stream<CollectorMessage> messageMember() {
    return remote.workspaceRemote
        .watchMembers(companyId: userSession.getCompanyId())
        .asyncMap((event) async {
          final data = await helper.collectDataRemote(
            remoteFunc: () async => event,
            localFunc: ({required dataToCache}) async {
              devLog(
                "Log WorkspaceRepositoryImp: watchWorkspaceMember: ${dataToCache.toString()}",
              );
              await local.workspaceLocal.saveMember(dataToCache as List);
            },
          );
          return messageCollector.getMessage(data);
        });
  }

  @override
  Stream<Set<ModelUser>> getUser() {
    return userCache.stream;
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
    final response = await helper.collectDataRemote(
      remoteFunc: () async =>
          await remote.workspaceRemote.createWorkspace(data.toJson()),
      localFunc: ({required dataToCache}) async => {},
    );
    return response.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(response);
  }

  @override
  Future<CollectorMessage?> deleteWorkspace({
    required String workspaceId,
  }) async {
    final response = await helper.collectDataRemote(
      remoteFunc: () async =>
          await remote.workspaceRemote.deleteWorkspace(workspaceId),
      localFunc: ({required dataToCache}) async => {},
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
    final response = await helper.collectDataRemote(
      remoteFunc: () async =>
          await remote.workspaceRemote.updateWorkspace(finalUpdated),
      localFunc: ({required dataToCache}) async => {},
    );
    return response.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(response);
  }
}
