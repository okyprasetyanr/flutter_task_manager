// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_member.dart';

class WorkspaceLocal {
  final LocalDatabase localDatabase;
  final ResponseWrapperLocal responseWrapper;

  WorkspaceLocal({required this.localDatabase, required this.responseWrapper});

  Future<void> saveWorkspaces(List<dynamic> remoteResults) async {
    for (final json in remoteResults) {
      final model = ModelWorkspace.fromJson(json);

      await localDatabase
          .into(localDatabase.workspaces)
          .insertOnConflictUpdate(
            Workspace(
              id: model.id,
              name: model.name,
              description: model.description,
              ownerId: model.ownerId,
              createdAt: model.createdAt,
              companyId: model.companyId,
            ),
          );
    }
  }

  Future<void> saveMember(List<dynamic> remoteResults) async {
    for (final json in remoteResults) {
      final model = ModelWorkspaceMember.fromJson(json);

      await localDatabase
          .into(localDatabase.workspaceMembers)
          .insertOnConflictUpdate(
            WorkspaceMember(
              workspaceId: model.workspaceId,
              userId: model.userId,
              role: model.role.name,
              companyId: model.companyId,
              id: model.id,
            ),
          );
    }
  }

  Future<List<Map<String, dynamic>>> getLocalWorkspaces() async {
    final query = await localDatabase.select(localDatabase.workspaces).get();
    return query.map((row) => row.toJson()).toList();
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
}
