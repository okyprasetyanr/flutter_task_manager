// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/workspace_detail/data/local/workspace_detail_local.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_member.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_filter/helper_date_filter.dart';

class WorkspaceDetailRepositoryImp implements WorkspaceDetailRepository {
  final RemoteServices remote;
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
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchProject({
    required String workspaceId,
  }) {
    return remote.workspaceDetailRemote
        .watchProject(workspaceId: workspaceId)
        .asyncMap((event) async {
          final data = await helper.collectDataRemote(
            remoteFunc: () async => event,
            localFunc: ({required dataToCache}) async => {},
          );
          return (data, messageCollector.getMessage(data));
        });
  }

  @override
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchProjectMember({required String workspaceId}) {
    return remote.workspaceDetailRemote
        .watchProjectMember(workspaceId: workspaceId)
        .asyncMap((event) async {
          final data = await helper.collectDataRemote(
            remoteFunc: () async => event,
            localFunc: ({required dataToCache}) async => {},
          );
          return (data, messageCollector.getMessage(data));
        });
  }

  @override
  Future<CollectorMessage?> createProject({
    required String name,
    required DateTime start,
    required DateTime end,
    required Set<(String userId, String role)> contributor,
    required String type,
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
          createdBy: userSession.userId!,
        ).toJson(),
      ),
      localFunc: ({required dataToCache}) async => {},
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
      );
    }

    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }

  @override
  Future<CollectorMessage?> updateProject({
    required ModelProjectMerge original,
    required ModelProjectMerge edited,
    required String role,
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
      final originalIds = original.dataProjectMember.map((e) => e.id).toSet();
      final editedIds = edited.dataProjectMember.map((e) => e.id).toSet();

      final Set<String> usersToCreate = edited.dataProjectMember
          .where((user) => !originalIds.contains(user.id))
          .map((e) => e.id)
          .toSet();

      final Set<String> usersToDelete = original.dataProjectMember
          .where((user) => !editedIds.contains(user.id))
          .map((e) => e.id)
          .toSet();
      if (usersToCreate.isNotEmpty) {
        await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceDetailRemote.createProjectMember(
            usersToCreate
                .map(
                  (e) => ModelProjectMember.createProjectMember(
                    projectId: original.dataProject.id,
                    workspaceId: original.dataProject.workspaceId,
                    userId: e,
                    role: role,
                  ).toJson(),
                )
                .toSet(),
          ),
          localFunc: ({required dataToCache}) async => {},
        );
      }

      if (usersToDelete.isNotEmpty) {
        await helper.collectDataRemote(
          remoteFunc: () => remote.workspaceDetailRemote.deleteProjectMember(
            usersToDelete.map((e) => e).toList(),
            original.dataProject.id,
          ),
          localFunc: ({required dataToCache}) async => {},
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
