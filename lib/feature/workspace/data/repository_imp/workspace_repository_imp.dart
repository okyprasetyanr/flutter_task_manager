// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/login/domain/model/model_company.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/repository/not_log_repository.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/workspace/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_member.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceRepositoryImp implements WorkspaceRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserRepository userRepo;
  final NotLogRepository notLogRepo;

  WorkspaceRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userRepo,
    required this.notLogRepo,
  });

  RealtimeChannel? _workspaceChannel;
  RealtimeChannel? _memberChannel;

  @override
  ModelCompany getCompanyName() {
    return userSession.getCompany();
  }

  ModelUser getAccount() {
    return userSession.getUser();
  }

  @override
  Future<void> initWorkspaceRealtime() async {
    final companyId = userSession.getCompany().companyId;

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
    final companyId = userSession.getCompany().companyId;

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
        .watchMember(companyId: userSession.getCompany().companyId)
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
        .watchWorkspace(companyId: userSession.getCompany().companyId)
        .map((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          return (data, messageCollector.getMessage(data));
        });
  }

  @override
  Stream<
    (
      Set<ModelNotification>,
      ModelUser,
      Set<ModelUser>,
      Set<ModelWorkspaceMerge>,
      String,

      CollectorMessage,
    )
  >
  watchDashboard() {
    return Rx.combineLatest4(
      watchUser(),
      watchWorkspace(),
      watchMember(),
      getNotification(),
      (a, b, c, d) {
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
              .toSet();

          return ModelWorkspaceMerge(
            dataWorkspace: workspace,
            dataMember: members,
          );
        }).toSet();

        return (
          d,
          getAccount(),
          a,
          dataWorkspace,
          getCompanyName().companyName,
          b.$2,
        );
      },
    );
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
          companyId: userSession.getCompany().companyId,
          userId: userSession.getUser().id,
        ).toJson(),
      ),
      localFunc: ({required dataToCache}) async => {},
    );

    if (data.containsKey(EnumFetchApiStatus.success)) {
      final dataMember = await helper.collectDataRemote(
        remoteFunc: () => remote.workspaceRemote.createWorkspaceMember(
          contributor
              .map(
                (e) => ModelWorkspaceMember.createWorkspaceMember(
                  workspaceId:
                      data[EnumFetchApiStatus.success][EnumWorkspace.id.value],
                  userId: e.$1,
                  role: e.$2,
                  companyId: userSession.getCompany().companyId,
                ).toJson(),
              )
              .toSet(),
        ),
        localFunc: ({required dataToCache}) async => {},
      );
      devLog(
        "Log WorkspaceRepositoryImp: createWorkspace: Member: $dataMember",
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

    devLog("Log WorkspaceRepositoryImp: update: data: $data");
    if (data.containsKey(EnumFetchApiStatus.success)) {
      final String workspaceId = original.dataWorkspace.id;

      final Map<String, EnumWorkspaceRole> contributorMap = {
        for (final c in contributor) c.$1: c.$2,
      };

      final Map<String, ModelWorkspaceMember> originalMemberMap = {
        for (final member in original.dataMember) member.userId: member,
      };

      final Set<String> currentContributorIds = contributor
          .map((c) => c.$1)
          .toSet();

      final Set<String> usersToCreate = currentContributorIds
          .where((userId) => !originalMemberMap.containsKey(userId))
          .toSet();

      final Set<String> usersToDelete = originalMemberMap.keys
          .where((userId) => !currentContributorIds.contains(userId))
          .toSet();

      final Set<String> usersToUpdate = currentContributorIds
          .where(
            (userId) =>
                originalMemberMap.containsKey(userId) &&
                originalMemberMap[userId]!.role != contributorMap[userId],
          )
          .toSet();

      devLog(
        "Log WorkspaceRepositoryImp: update: checked: "
        "Create: ${usersToCreate.length}, "
        "Delete: ${usersToDelete.length}, "
        "Update: ${usersToUpdate.length}",
      );

      if (usersToCreate.isNotEmpty) {
        final dataMemberCreate = await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceRemote.createWorkspaceMember(
            usersToCreate
                .map(
                  (userId) => ModelWorkspaceMember.createWorkspaceMember(
                    workspaceId: workspaceId,
                    companyId: userSession.getCompany().companyId,
                    userId: userId,
                    role: contributorMap[userId] ?? EnumWorkspaceRole.member,
                  ).toJson(),
                )
                .toSet(),
          ),
          localFunc: ({required dataToCache}) async => {},
        );

        devLog("Log WorkspaceRepositoryImp: update: create: $dataMemberCreate");
      }

      if (usersToUpdate.isNotEmpty) {
        final dataMemberUpdate = await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceRemote.updateWorkspaceMember(
            usersToUpdate
                .map(
                  (userId) => ModelWorkspaceMember.createWorkspaceMember(
                    id: originalMemberMap[userId]!.id,
                    workspaceId: workspaceId,
                    companyId: userSession.getCompany().companyId,
                    userId: userId,
                    role: contributorMap[userId] ?? EnumWorkspaceRole.member,
                  ).toJson(),
                )
                .toSet(),
          ),
          localFunc: ({required dataToCache}) async => {},
        );

        devLog(
          "Log WorkspaceRepositoryImp: update: update_member: $dataMemberUpdate",
        );
      }

      if (usersToDelete.isNotEmpty) {
        final dataMemberDelete = await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceRemote.deleteWorkspaceMember(
            userId: usersToDelete.toList(),
            workspaceId: workspaceId,
          ),
          localFunc: ({required dataToCache}) async => {},
        );
        devLog("Log WorkspaceRepositoryImp: update: delete: $dataMemberDelete");
      }
    }

    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }

  @override
  Stream<Set<ModelNotification>> getNotification() {
    return notLogRepo.getNotification();
  }

  @override
  Future<CollectorMessage?> createMember({
    required String name,
    required String email,
  }) async {
    final data = await helper.collectDataRemote(
      remoteFunc: () async => await remote.userRemote.createMember(
        ModelUser.createUser(
          companyId: userSession.getCompany().companyId,
          email: email,
          name: name,
        ).toJson(),
      ),
      localFunc: ({required dataToCache}) async => {},
    );
    devLog("Log WorkspaceRepositoryImp: createMember: data: $data");

    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }

  @override
  Future<CollectorMessage?> deleteMember({required String idMember}) async {
    final data = await helper.collectDataRemote(
      remoteFunc: () async => await remote.userRemote.deleteMember(
        userId: idMember,
        idCompany: userSession.company!.companyId,
      ),
      localFunc: ({required dataToCache}) async => {},
    );
    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }

  @override
  Future<CollectorMessage?> updateMember({
    required ModelUser original,
    required ModelUser edited,
  }) async {
    final finalUpdated = ModelUser.userGetChangedData(
      original: original.toJson(),
      edited: edited.toJson(),
    );

    final data = await helper.collectDataRemote(
      remoteFunc: () async =>
          await remote.userRemote.updatemember(finalUpdated),
      localFunc: ({required dataToCache}) async => {},
    );

    devLog("Log WorkspaceRepositoryImp: updateMember: data: $finalUpdated");

    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }
}
