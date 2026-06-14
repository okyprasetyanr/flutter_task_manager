// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/workspace/data/local/workspace_local.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

class WorkspaceRepositoryImp implements WorkspaceRepository {
  final RemoteService remote;
  final WorkspaceLocal local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;

  WorkspaceRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });

  @override
  String getCompanyName() {
    return userSession.getCompanyName();
  }

  @override
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchWorkspace() {
    return remote.workspaceRemote
        .watchWorkspaces(companyId: userSession.getCompanyId())
        .asyncMap((rawMapFromRemote) async {
          final Map<EnumFetchApiStatus, dynamic> data = await helper
              .helperCollectData(
                remoteFunc: () async => rawMapFromRemote,
                localFunc: () async => {},
              );
          final collectorMessage = messageCollector.getMessage(data);
          return (data, collectorMessage);
        });
  }

  @override
  Future<CollectorMessage?> createWorkspace({
    required ModelWorkspace data,
  }) async {
    final response = await helper.helperCollectData(
      remoteFunc: () async =>
          await remote.workspaceRemote.createWorkspace(data.toJson()),
      localFunc: () async => {},
    );
    return response.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(response);
  }

  @override
  Future<CollectorMessage?> deleteWorkspace({
    required String workspaceId,
  }) async {
    final response = await helper.helperCollectData(
      remoteFunc: () async =>
          await remote.workspaceRemote.deleteWorkspace(workspaceId),
      localFunc: () async => {},
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
    final response = await helper.helperCollectData(
      remoteFunc: () async =>
          await remote.workspaceRemote.updateWorkspace(finalUpdated),
      localFunc: () async => {},
    );
    return response.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(response);
  }
}
