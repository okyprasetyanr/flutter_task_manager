import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_member.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceDetailLocal {
  final LocalDatabase localDatabase;
  final ResponseWrapperLocal responseWrapper;

  WorkspaceDetailLocal({
    required this.localDatabase,
    required this.responseWrapper,
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

  Future<void> saveProject(List<dynamic> remoteResults) async {
    try {
      devLog("Log WorkspaceDetailLocal: saveProject: checked");
      for (final json in remoteResults) {
        final model = ModelProject.fromJson(json);
        devLog("Log WorkspaceDetailLocal: saveProject: inLoop: checked");

        await localDatabase
            .into(localDatabase.projects)
            .insertOnConflictUpdate(
              Project(
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
        devLog("Log WorkspaceDetailLocal: saveProject: inLoop: $model");
      }
    } catch (e) {
      devLog("Log WorkspaceDetailLocal: saveProject: error: ${e.toString()}");
    }
  }

  Future<void> saveMember(List<dynamic> remoteResults) async {
    for (final json in remoteResults) {
      final model = ModelProjectMember.fromJson(json);

      await localDatabase
          .into(localDatabase.projectMembers)
          .insertOnConflictUpdate(
            ProjectMember(
              projectId: model.projectId,
              workspaceId: model.workspaceId,
              userId: model.userId,
              role: model.role,
              id: model.id,
            ),
          );
    }
  }
}
