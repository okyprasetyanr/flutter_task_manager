import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/feature/task_detail/domain/model/model_comment.dart';

class TaskDetailLocal {
  final LocalDatabase localDatabase;
  final ResponseWrapperLocal responseWrapper;
  final SyncTable syncTable;

  TaskDetailLocal({
    required this.localDatabase,
    required this.responseWrapper,
    required this.syncTable,
  });

  Future<void> syncComment({
    required List<Map<String, dynamic>> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelComment, Comment>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelComment.fromJson(e)).toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.comments,
      idColumn: localDatabase.comments.id,
      modelData: (ModelComment model) => Comment(
        id: model.id,
        taskId: model.taskId,
        userId: model.userId,
        content: model.content,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchComment({required String taskId}) {
    final query = localDatabase.select(localDatabase.comments)
      ..where((tbl) => tbl.taskId.equals(taskId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<Comment> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteComment(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.comments,
      idColumn: localDatabase.comments.id,
    );
  }
}
