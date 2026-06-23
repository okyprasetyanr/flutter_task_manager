// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/stream_manager/stream_manager.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/workspace/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_member.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceRepositoryImp implements WorkspaceRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final StreamManager streamManager;
  final UserRepository userRepo;

  WorkspaceRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.streamManager,
    required this.userRepo,
  });

  RealtimeChannel? _workspaceChannel;
  RealtimeChannel? _memberChannel;

  @override
  String getCompanyName() {
    return userSession.getCompanyName();
  }

  @override
  Future<void> initWorkspaceRealtime() async {
    final companyId = userSession.getCompanyId();

    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .workspaceRemote
          .getAllWorkspaces(companyId: companyId);
      await local.workspaceLocal.syncWorkspace(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log WorkspaceRepositoryImp: error: $e");
    }

    if (_workspaceChannel != null) {
      remote.workspaceRemote.removeWorkspaceChannel(_workspaceChannel!);
    }
    _workspaceChannel = remote.workspaceRemote.buildWorkspaceChannel(companyId);

    _workspaceChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.workspaces.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumWorkspace.companyId.value,
            value: companyId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.workspaceLocal.deleteWorkspace(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.workspaceLocal.syncWorkspace(remoteResults: [data]);
              }
            } catch (e) {
              devLog("Log WorkspaceRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log WorkspaceRepositoryImp: error Supabase: $error");
          }
        });
  }

  @override
  Future<void> initMemberRealtime() async {
    final companyId = userSession.getCompanyId();

    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .workspaceRemote
          .getAllMembers(companyId: companyId);
      await local.workspaceLocal.syncMember(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log WorkspaceRepositoryImp: error: $e");
    }

    if (_memberChannel != null) {
      remote.workspaceRemote.removeMemberChannel(_memberChannel!);
    }
    _memberChannel = remote.workspaceRemote.buildMemberChannel(companyId);

    _memberChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.workspaceMembers.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumWorkspace.companyId.value,
            value: companyId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.workspaceLocal.deleteMember(deleteId.toString());
                }
              } else {
                final data = payload.newRecord;
                await local.workspaceLocal.syncMember(remoteResults: [data]);
              }
            } catch (e) {
              devLog("Log WorkspaceRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log WorkspaceRepositoryImp: error Supabase: $error");
          }
        });
  }

  @override
  void disposeRealtime() {
    if (_workspaceChannel != null) {
      remote.workspaceRemote.removeWorkspaceChannel(_workspaceChannel!);
      _workspaceChannel = null;
    }
    if (_memberChannel != null) {
      remote.workspaceRemote.removeMemberChannel(_memberChannel!);
      _memberChannel = null;
    }
  }

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

  Stream<Set<ModelUser>> watchUser() {
    return userRepo.getUser();
  }

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
  Stream<WorkspaceStateLoaded> watchDashboard() {
    return Rx.combineLatest3(watchUser(), watchWorkspace(), watchMember(), (
      a,
      b,
      c,
    ) {
      final workspaceList = (b.$1[EnumFetchApiStatus.success] as List)
          .map((e) => ModelWorkspace.fromDrift(e))
          .toList();

      final memberList = c.$1.containsKey(EnumFetchApiStatus.success)
          ? (c.$1[EnumFetchApiStatus.success] as List)
                .map((e) => ModelWorkspaceMember.fromDrift(e))
                .toList()
          : <ModelWorkspaceMember>[];

      final dataWorkspace = workspaceList.map((workspace) {
        final members = memberList
            .where((m) => m.workspaceId == workspace.id)
            .toList();

        final matchedUsers = a
            .where((u) => members.any((m) => m.userId == u.id))
            .toSet();

        return ModelWorkspaceMerge(
          dataWorkspace: workspace,
          dataWorkspaceMember: matchedUsers,
        );
      }).toSet();

      return WorkspaceStateLoaded(
        dataUser: a,
        dataWorkspace: dataWorkspace,
        companyName: getCompanyName(),
        status: EnumStatusState.none,
        error: b.$2.error,
        failed: b.$2.failed,
      );
    });
  }

  @override
  Future<CollectorMessage?> createWorkspace({
    required String name,
    required String description,
    required Set<(String userId, EnumWorkspaceRole role)> contributor,
  }) async {
    final data = await helper.collectDataRemote(
      remoteFunc: () async => await remote.workspaceRemote.createWorkspace(
        ModelWorkspace.createWorkspace(
          name: name,
          description: description,
          companyId: userSession.getCompanyId(),
          userId: userSession.getUserId(),
        ).toJson(),
      ),
      localFunc: ({required dataToCache}) async => {},
    );

    if (data.containsKey(EnumFetchApiStatus.success)) {
      await helper.collectDataRemote(
        remoteFunc: () => remote.workspaceRemote.createWorkspaceMember(
          contributor
              .map(
                (e) => ModelWorkspaceMember.createWorkspaceMember(
                  workspaceId:
                      data[EnumFetchApiStatus.success][EnumWorkspace.id.value],
                  userId: e.$1,
                  role: e.$2,
                  companyId: userSession.getCompanyId(),
                ).toJson(),
              )
              .toSet(),
        ),
        localFunc: ({required dataToCache}) async => {},
      );
    }
    devLog("Log WorkspaceRepositoryImp: createWorkspace: $data");
    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
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
    required ModelWorkspaceMerge original,
    required ModelWorkspaceMerge edited,
    required Set<(String userId, EnumWorkspaceRole role)> contributor,
  }) async {
    final finalUpdated = ModelWorkspace.workspaceGetChangedData(
      original: original.dataWorkspace.toJson(),
      edited: edited.dataWorkspace.toJson(),
    );
    final data = await helper.collectDataRemote(
      remoteFunc: () async =>
          await remote.workspaceRemote.updateWorkspace(finalUpdated),
      localFunc: ({required dataToCache}) async => {},
    );

    if (data.containsKey(EnumFetchApiStatus.success)) {
      final originalIds = original.dataWorkspaceMember.map((e) => e.id).toSet();
      final editedIds = edited.dataWorkspaceMember.map((e) => e.id).toSet();

      final Set<String> usersToCreate = edited.dataWorkspaceMember
          .where((user) => !originalIds.contains(user.id))
          .map((e) => e.id)
          .toSet();

      final Set<String> usersToDelete = original.dataWorkspaceMember
          .where((user) => !editedIds.contains(user.id))
          .map((e) => e.id)
          .toSet();

      if (usersToCreate.isNotEmpty) {
        await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceDetailRemote.createProjectMember(
            usersToCreate
                .map(
                  (e) => ModelWorkspaceMember.createWorkspaceMember(
                    workspaceId:
                        data[EnumFetchApiStatus.success][EnumProject.id.value],
                    companyId: userSession.getCompanyId(),
                    userId: e,
                    role: contributor
                        .firstWhere((element) => element.$1 == e)
                        .$2,
                  ).toJson(),
                )
                .toSet(),
          ),
          localFunc: ({required dataToCache}) async => {},
        );
      }

      if (usersToDelete.isNotEmpty) {
        await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceRemote.deleteWorkspaceMember(
            userId: usersToDelete.map((e) => e).toList(),
            workspaceId: original.dataWorkspace.id,
          ),
          localFunc: ({required dataToCache}) async => {},
        );
      }
    }

    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }

  // @override
  // Stream<CollectorMessage> watchMessage() {
  //   return remote.workspaceRemote
  //       .watchWorkspaces(companyId: userSession.getCompanyId())
  //       .asyncMap((event) async {
  //         final data = await helper.collectDataRemote(
  //           remoteFunc: () async => event,
  //           localFunc: ({required dataToCache}) async {
  //             devLog(
  //               "Log WorkspaceRepositoryImp: messageWorkspace: data: ${dataToCache.toString()}",
  //             );

  //             await local.workspaceLocal.syncWorkspace(
  //               remoteResults: [dataToCache],
  //             );
  //           },
  //         );
  //         return messageCollector.getMessage(data);
  //       });
  // }

  // @override
  // Stream<CollectorMessage> watchMessageMember() {
  //   return remote.workspaceRemote
  //       .watchMembers(companyId: userSession.getCompanyId())
  //       .asyncMap((event) async {
  //         final data = await helper.collectDataRemote(
  //           remoteFunc: () async => event,
  //           localFunc: ({required dataToCache}) async {
  //             devLog(
  //               "Log WorkspaceRepositoryImp: watchWorkspaceMember: ${dataToCache.toString()}",
  //             );
  //             await local.workspaceLocal.syncMember(dataToCache);
  //           },
  //         );
  //         return messageCollector.getMessage(data);
  //       });
  // }
}
