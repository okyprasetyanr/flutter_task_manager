// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_member.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_filter/helper_date_filter.dart';

class WorkspaceDetailRepositoryImp implements WorkspaceDetailRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserRepository userRepo;

  WorkspaceDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userRepo,
  });

  RealtimeChannel? _projectChannel;
  RealtimeChannel? _memberChannel;

  @override
  Future<void> initProjectRealtime({required String workspaceId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .workspaceDetailRemote
          .getAllProjects(workspaceId: workspaceId);
      await local.workspaceDetailLocal.syncProject(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log WorkspaceRepositoryImp: error: $e");
    }

    if (_projectChannel != null) {
      remote.workspaceDetailRemote.removeProjectChannel(_projectChannel!);
    }
    _projectChannel = remote.workspaceDetailRemote.buildProjectChannel(
      workspaceId,
    );

    _projectChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.projects.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumProject.workspaceId.value,
            value: workspaceId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];
                devLog("Log WorkspaceDetailRepositoryImp: delete: $deleteId");
                if (deleteId != null) {
                  await local.workspaceDetailLocal.deleteProject(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.workspaceDetailLocal.syncProject(
                  remoteResults: [data],
                );
              }
            } catch (e) {
              devLog("Log WorkspaceDetailRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log WorkspaceDetailRepositoryImp: error Supabase: $error");
          }
        });
  }

  @override
  Future<void> initMemberRealtime({required String workspaceId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .workspaceDetailRemote
          .getAllMembers(workspaceId: workspaceId);
      await local.workspaceDetailLocal.syncMember(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log WorkspaceRepositoryImp: error: $e");
    }

    if (_memberChannel != null) {
      remote.workspaceDetailRemote.removeMemberChannel(_memberChannel!);
    }
    _memberChannel = remote.workspaceDetailRemote.buildMemberChannel(
      workspaceId,
    );

    _memberChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.projectMembers.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumProjectMember.workspaceId.value,
            value: workspaceId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.workspaceDetailLocal.deleteMember(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.workspaceDetailLocal.syncMember(
                  remoteResults: [data],
                );
              }
            } catch (e) {
              devLog("Log WorkspaceDetailRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log WorkspaceDetailRepositoryImp: error Supabase: $error");
          }
        });
  }

  @override
  void disposeRealtime() {
    if (_projectChannel != null) {
      remote.workspaceDetailRemote.removeProjectChannel(_projectChannel!);
      _projectChannel = null;
    }
    if (_memberChannel != null) {
      remote.workspaceDetailRemote.removeMemberChannel(_memberChannel!);
      _memberChannel = null;
    }
  }

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchProject({
    required String workspaceId,
  }) {
    return local.workspaceDetailLocal
        .watchProject(workspaceId: workspaceId)
        .asyncMap((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          return (data, messageCollector.getMessage(data));
        });
  }

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchMember({
    required String workspaceId,
  }) {
    return local.workspaceDetailLocal
        .watchMember(workspaceId: workspaceId)
        .asyncMap((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          return (data, messageCollector.getMessage(data));
        });
  }

  Stream<Set<ModelUser>> watchUser() {
    return userRepo.getUser();
  }

  @override
  Stream<
    (Set<ModelUser>, Set<ModelProjectMerge>, Set<String>, CollectorMessage)
  >
  watchDashboard({required ModelWorkspaceMerge workspace}) {
    return Rx.combineLatest3(
      watchUser(),
      watchProject(workspaceId: workspace.dataWorkspace.id),
      watchMember(workspaceId: workspace.dataWorkspace.id),
      (a, b, c) {
        final projectList = (b.$1[EnumFetchApiStatus.success] as List)
            .map((e) => ModelProject.fromDrift(e))
            .toSet();

        final memberList = c.$1.containsKey(EnumFetchApiStatus.success)
            ? (c.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelProjectMember.fromDrift(e))
                  .toSet()
            : <ModelProjectMember>[];

        final dataProject =
            projectList.map((project) {
                final members = memberList
                    .where((e) => e.projectId == project.id)
                    .toSet();

                return ModelProjectMerge(
                  dataProject: project,
                  dataMember: members,
                );
              }).toList()
              ..sort((a, b) => a.dataProject.end.compareTo(b.dataProject.end));

        devLog("Log watchDashboard: projectMember: data: $projectList");

        final dataType = {"All", ...EnumProjectType.values.map((e) => e.text)};

        return (a, dataProject.toSet(), dataType, b.$2);
      },
    );
  }

  @override
  Future<CollectorMessage?> createProject({
    required String name,
    required DateTime start,
    required DateTime end,
    required Set<(String userId, EnumProjectRole role)> contributor,
    required EnumProjectType type,
    required String workspaceId,
  }) async {
    final data = await helper.collectDataRemote(
      remoteFunc: () => remote.workspaceDetailRemote.createProject(
        data: ModelProject.createProject(
          name: name,
          start: start,
          end: end,
          createdAt: dateNowYMDBLOC(),
          totalContribut: contributor.length,
          type: type,
          status: EnumProjectStatus.todo,
          workspaceId: workspaceId,
          createdBy: userSession.getUser().id,
        ).toJson(),
      ),
      localFunc: ({required dataToCache}) async => {},
      pageName: "Workspace Detail",
    );

    if (data.containsKey(EnumFetchApiStatus.success)) {
      await helper.collectDataRemote(
        remoteFunc: () => remote.workspaceDetailRemote.createProjectMember(
          contributor
              .map(
                (e) => ModelProjectMember.createProjectMember(
                  projectId:
                      data[EnumFetchApiStatus.success][EnumProject.id.value],
                  workspaceId: workspaceId,
                  userId: e.$1,
                  role: e.$2,
                ).toJson(),
              )
              .toSet(),
        ),
        localFunc: ({required dataToCache}) async => {},
        pageName: "Workspace Detail M",
      );
    }
    devLog("Log WorkspaceRepositoryImp: createProject: data: $data");
    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }

  @override
  Future<CollectorMessage?> updateProject({
    required ModelProjectMerge original,
    required ModelProjectMerge edited,
    required Set<(String userId, EnumProjectRole role)> contributor,
  }) async {
    final data = await helper.collectDataRemote(
      remoteFunc: () => remote.workspaceDetailRemote.updateProject(
        ModelProject.projectGetChangedData(
          original: original.dataProject.toJson(),
          edited: edited.dataProject.toJson(),
        ),
      ),
      localFunc: ({required dataToCache}) async => {},
    );

    if (data.containsKey(EnumFetchApiStatus.success)) {
      final Map<String, EnumProjectRole> contributorMap = {
        for (final c in contributor) c.$1: c.$2,
      };

      final Map<String, ModelProjectMember> originalMemberMap = {
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
        "Log WorkspaceDetailRepositoryImp: UpdateProject: dataMember: userToCreate:${usersToCreate.length}, userToUpdate:${usersToUpdate.length}, userToDelete:${usersToDelete.length}",
      );
      if (usersToCreate.isNotEmpty) {
        final dataMember = await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceDetailRemote.createProjectMember(
            usersToCreate
                .map(
                  (e) => ModelProjectMember.createProjectMember(
                    projectId:
                        data[EnumFetchApiStatus.success][EnumProject.id.value],
                    workspaceId:
                        data[EnumFetchApiStatus.success][EnumProject
                            .workspaceId
                            .value],
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

        devLog(
          "Log WorkspaceDetailRepositoryImp: UpdateProject: dataMember: create: $dataMember",
        );
      }

      if (usersToUpdate.isNotEmpty) {
        final dataDelete = await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceDetailRemote.updateProjectMember(
            usersToUpdate.map((e) {
              devLog(
                "Log WorkspaceRepositoryImp: updateProject: dataMember: update: id: ${originalMemberMap[e]!.id}",
              );
              return ModelProjectMember.createProjectMember(
                id: originalMemberMap[e]!.id,
                projectId:
                    data[EnumFetchApiStatus.success][EnumProject.id.value],
                workspaceId:
                    data[EnumFetchApiStatus.success][EnumProject
                        .workspaceId
                        .value],
                userId: e,
                role: contributor.firstWhere((element) => element.$1 == e).$2,
              ).toJson();
            }).toSet(),
          ),
          localFunc: ({required dataToCache}) async => {},
        );
        devLog(
          "Log WorkspaceRepositoryImp: updateProject: dataMember: update: $dataDelete",
        );
      }

      if (usersToDelete.isNotEmpty) {
        final dataDelete = await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceDetailRemote.deleteProjectMember(
            usersToDelete.map((e) => e).toList(),
            original.dataProject.id,
          ),
          localFunc: ({required dataToCache}) async => {},
        );
        devLog(
          "Log WorkspaceDetailRepositoryImp: updateProject: dataMember: delete: $dataDelete",
        );
      }
    }

    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }

  @override
  Future<CollectorMessage?> deleteProject(String idProject) async {
    final data = await helper.collectDataRemote(
      remoteFunc: () => remote.workspaceDetailRemote.deleteProject(idProject),
      localFunc: ({required dataToCache}) async => {},
    );
    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }
}
