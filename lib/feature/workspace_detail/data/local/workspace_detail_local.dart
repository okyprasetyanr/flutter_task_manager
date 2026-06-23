// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_member.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceDetailLocal {
  final LocalDatabase localDatabase;
  final ResponseWrapperLocal responseWrapper;
  final SyncTable syncTable;

  WorkspaceDetailLocal({
    required this.localDatabase,
    required this.responseWrapper,
    required this.syncTable,
  });

  Stream<Map<String, dynamic>> watchProject({required String workspaceId}) {
    final query = localDatabase.select(localDatabase.projects)
      ..where((tbl) => tbl.workspaceId.equals(workspaceId));

    return responseWrapper.wrapStream(
      getStream: () => query.watch().map(
        (List<Project> event) => event.map((e) {
          devLog("Log WorkspaceDetailLocal: watchProject: ${e.toJson()}");
          return e.toJson();
        }).toList(),
      ),
    );
  }

  Stream<Map<String, dynamic>> watchMember({required String workspaceId}) {
    final query = localDatabase.select(localDatabase.projectMembers)
      ..where((tbl) => tbl.workspaceId.equals(workspaceId));

    return responseWrapper.wrapStream(
      getStream: () => query.watch().map(
        (List<ProjectMember> event) => event.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> syncProject({
    required List<Map<String, dynamic>> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelProject, Project>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelProject.fromJson(e)).toList(),
      getLocalId: (localRow) => localRow.id,
      getRemoteId: (remoteModel) => remoteModel.id,
      tableName: localDatabase.projects,
      idColumn: localDatabase.projects.id,
      modelData: (ModelProject model) => Project(
        id: model.id,
        name: model.name,
        type: model.type,
        status: model.status.text,
        createdBy: model.createdBy,
        totalContribut: model.totalContribut,
        createdAt: model.createdAt,
        start: model.start,
        end: model.end,
        workspaceId: model.workspaceId,
      ),
    );
  }

  Future<void> syncMember({
    required List<Map<String, dynamic>> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelProjectMember, ProjectMember>(
      init: init,
      remoteModels: remoteResults
          .map((e) => ModelProjectMember.fromJson(e))
          .toList(),
      getLocalId: (localRow) => localRow.id,
      getRemoteId: (remoteModel) => remoteModel.id,
      tableName: localDatabase.projectMembers,
      idColumn: localDatabase.projectMembers.id,
      modelData: (ModelProjectMember model) => ProjectMember(
        projectId: model.projectId,
        workspaceId: model.workspaceId,
        userId: model.userId,
        role: model.role,
        id: model.id,
      ),
    );
  }

  Future<void> deleteProject(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.projects,
      idColumn: localDatabase.projects.id,
    );
  }

  Future<void> deleteMember(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.projectMembers,
      idColumn: localDatabase.projectMembers.id,
    );
  }
}
