// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_member.dart';
import 'package:task_manager/shared/enum.dart';

class WorkspaceLocal {
  final LocalDatabase localDatabase;
  final ResponseWrapperLocal responseWrapper;
  final SyncTable syncTable;

  WorkspaceLocal({
    required this.localDatabase,
    required this.responseWrapper,
    required this.syncTable,
  });

  Future<void> syncWorkspace({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelWorkspace, Workspace>(
      init: init,
      remoteModels: remoteResults
          .map((e) => ModelWorkspace.fromJson(e))
          .toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.workspaces,
      idColumn: localDatabase.workspaces.id,
      modelData: (ModelWorkspace model) => Workspace(
        id: model.id,
        name: model.name,
        description: model.description,
        ownerId: model.ownerId,
        createdAt: model.createdAt,
        companyId: model.companyId,
      ),
    );
  }

  Future<void> syncMember({
    required List<Map<String, dynamic>> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelWorkspaceMember, WorkspaceMember>(
      init: init,
      remoteModels: remoteResults
          .map((e) => ModelWorkspaceMember.fromJson(e))
          .toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.workspaceMembers,
      idColumn: localDatabase.workspaceMembers.id,
      modelData: (ModelWorkspaceMember model) => WorkspaceMember(
        workspaceId: model.workspaceId,
        userId: model.userId,
        role: model.role.text,
        companyId: model.companyId,
        id: model.id,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchWorkspace({required String companyId}) {
    final query = localDatabase.select(localDatabase.workspaces)
      ..where((tbl) => tbl.companyId.equals(companyId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<Workspace> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Stream<Map<String, dynamic>> watchMember({required String companyId}) {
    final query = localDatabase.select(localDatabase.workspaceMembers)
      ..where((tbl) => tbl.companyId.equals(companyId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<WorkspaceMember> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteWorkspace(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.workspaces,
      idColumn: localDatabase.workspaces.id,
    );
  }

  Future<void> deleteMember(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.workspaceMembers,
      idColumn: localDatabase.workspaceMembers.id,
    );
  }
}
