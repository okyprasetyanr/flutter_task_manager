// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/local_database/local_database.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/model/model_label.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/model/model_task.dart';
import 'package:task_manager/shared/model/model_task_labels.dart';

class ProjectDetailLocal {
  final LocalDatabase localDatabase;
  final SyncTable syncTable;
  final ResponseWrapperLocal responseWrapper;

  ProjectDetailLocal({
    required this.localDatabase,
    required this.syncTable,
    required this.responseWrapper,
  });

  Future<void> syncTask({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelTask, Task>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelTask.fromJson(e)).toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.tasks,
      idColumn: localDatabase.tasks.id,
      modelData: (ModelTask model) => Task(
        id: model.id,
        projectId: model.projectId,
        sprintId: model.sprintId ?? "",
        title: model.title,
        description: model.description,
        status: model.status.text,
        priority: model.priority.text,
        storyPoint: model.storyPoint,
        reporterId: model.reporterId,
        assigneeId: model.assigneeId,
        startDate: model.startDate,
        dueDate: model.dueDate,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchTask({required String projectId}) {
    final query = localDatabase.select(localDatabase.tasks)
      ..where((tbl) => tbl.projectId.equals(projectId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<Task> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteTask(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.tasks,
      idColumn: localDatabase.tasks.id,
    );
  }

  Future<void> syncTaskLabel({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelTaskLabels, TaskLabel>(
      init: init,
      remoteModels: remoteResults
          .map((e) => ModelTaskLabels.fromJson(e))
          .toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.taskLabels,
      idColumn: localDatabase.taskLabels.id,
      modelData: (ModelTaskLabels model) => TaskLabel(
        id: model.id,
        taskId: model.taskId,
        labelId: model.labelId,
        projectId: model.projectId,
      ),
    );
  }

  Future<void> deleteTaskLabel(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.taskLabels,
      idColumn: localDatabase.taskLabels.id,
    );
  }

  Stream<Map<String, dynamic>> watchTaskLabel({required String projectId}) {
    final query = localDatabase.select(localDatabase.taskLabels)
      ..where((tbl) => tbl.projectId.equals(projectId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<TaskLabel> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> syncSubTask({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelSubTask, SubTask>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelSubTask.fromJson(e)).toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.subTasks,
      idColumn: localDatabase.subTasks.id,
      modelData: (ModelSubTask model) => SubTask(
        id: model.id,
        taskId: model.taskId,
        title: model.title,
        isDone: model.isDone,
        projectId: model.projectId,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchSubTask({required String projectId}) {
    final query = localDatabase.select(localDatabase.subTasks)
      ..where((tbl) => tbl.projectId.equals(projectId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<SubTask> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteSubTask(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.subTasks,
      idColumn: localDatabase.subTasks.id,
    );
  }

  Future<void> syncLabel({
    required List<dynamic> remoteResults,
    bool init = false,
  }) async {
    await syncTable.syncTable<ModelLabel, Label>(
      init: init,
      remoteModels: remoteResults.map((e) => ModelLabel.fromJson(e)).toList(),
      getRemoteId: (model) => model.id,
      getLocalId: (row) => row.id,
      tableName: localDatabase.labels,
      idColumn: localDatabase.labels.id,
      modelData: (ModelLabel model) => Label(
        id: model.id,
        name: model.name,
        color: model.color,
        companyId: model.companyId,
      ),
    );
  }

  Stream<Map<String, dynamic>> watchLabel({required String companyId}) {
    final query = localDatabase.select(localDatabase.labels)
      ..where((tbl) => tbl.companyId.equals(companyId));

    return responseWrapper.wrapStream(
      getStream: () {
        return query.watch().map((List<Label> event) {
          return event.map((row) => row.toJson()).toList();
        });
      },
    );
  }

  Future<void> deleteLabel(String id) async {
    await syncTable.deleteData(
      id: id,
      tableName: localDatabase.labels,
      idColumn: localDatabase.labels.id,
    );
  }
}
