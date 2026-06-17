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
  List<ModelUser> getUser() {
    return userCache.getUser();
  }

  @override
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchProject({
    required String workspaceId,
  }) {
    return remote.workspaceDetailRemote
        .watchProject(workspaceId: workspaceId)
        .asyncMap((event) async {
          final data = await helper.helperCollectData(
            remoteFunc: () async => event,
            localFunc: () async => {},
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
          final data = await helper.helperCollectData(
            remoteFunc: () async => event,
            localFunc: () async => {},
          );
          return (data, messageCollector.getMessage(data));
        });
  }

  @override
  Future<CollectorMessage?> createProject({
    required String name,
    required DateTime start,
    required DateTime end,
    required int totalContribut,
    required String type,
    required String workspaceId,
  }) async {
    final data = await helper.helperCollectData(
      remoteFunc: () => remote.workspaceDetailRemote.createProject(
        data: ModelProject.createProject(
          name: name,
          start: start,
          end: end,
          createdAt: dateNowYMDBLOC(),
          totalContribut: totalContribut,
          type: type,
          status: EnumProjectStatus.todo,
          workspaceId: workspaceId,
          createdBy: userSession.userId!,
        ).toJson(),
      ),
      localFunc: () => {},
    );
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
    final data = await helper.helperCollectData(
      remoteFunc: () => remote.workspaceDetailRemote.updateProject(
        ModelProject.projectGetChangedData(
          original: original.dataProject.toJson(),
          edited: edited.dataProject.toJson(),
        ),
      ),
      localFunc: () => {},
    );

    final originalIds = original.dataProjectMember.map((e) => e.id).toSet();
    final editedIds = edited.dataProjectMember.map((e) => e.id).toSet();

    final List<ModelUser> usersToCreate = edited.dataProjectMember
        .where((user) => !originalIds.contains(user.id))
        .toList();

    final List<ModelUser> usersToDelete = original.dataProjectMember
        .where((user) => !editedIds.contains(user.id))
        .toList();

    if (usersToCreate.isNotEmpty) {
      helper.helperCollectData(
        remoteFunc: () => remote.workspaceDetailRemote.updateProjectMember(
          usersToCreate
              .map(
                (e) => ModelProjectMember.createProjectMember(
                  projectId: original.dataProject.id,
                  workspaceId: original.dataProject.workspaceId,
                  userId: e.id,
                  role: role,
                ).toJson(),
              )
              .toList(),
        ),
        localFunc: () => {},
      );
    }

    if (usersToDelete.isNotEmpty) {
      helper.helperCollectData(
        remoteFunc: () => remote.workspaceDetailRemote.deleteProjectMember(
          usersToDelete.map((e) => e.id).toList(),
          original.dataProject.id,
        ),
        localFunc: () => {},
      );
    }
  }

  @override
  Future<CollectorMessage?> deleteProject(String idProject) async {
    final data = await helper.helperCollectData(
      remoteFunc: () => remote.workspaceDetailRemote.deleteProject(idProject),
      localFunc: () => {},
    );
    return data.containsKey(EnumFetchApiStatus.success)
        ? null
        : messageCollector.getMessage(data);
  }
}
