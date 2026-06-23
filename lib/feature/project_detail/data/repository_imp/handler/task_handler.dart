import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class TaskHandler {
  final LocalServices local;
  final RemoteServices remote;
  final CollectorMessage messageCollector;
  final CollectData helper;

  TaskHandler({
    required this.local,
    required this.remote,
    required this.messageCollector,
    required this.helper,
  });

  RealtimeChannel? taskChannel;
  Future<void> initTaskRealtime({required String projectId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .projectDetailRemote
          .task
          .getAllTask(projectId: projectId);
      await local.projectDetailLocal.task.syncTask(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog(
        "Log ProjectDetailRepositoryImp: initTaskRealtime: init: error: $e",
      );
    }
    if (taskChannel != null) {
      remote.projectDetailRemote.task.removeTaskChannel(taskChannel!);
    }
    taskChannel = remote.projectDetailRemote.task.buildTaskChannel(projectId);

    taskChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.tasks.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumTask.projectId.value,
            value: projectId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.projectDetailLocal.task.deleteTask(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.projectDetailLocal.task.syncTask(
                  remoteResults: [data],
                );
              }
            } catch (e) {
              devLog(
                "Log ProjectDetailRepositoryImp: initTaskRealtime: error: $e",
              );
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log ProjectDetailRepositoryImp: error Supabase: $error");
          }
        });
  }

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchTask({
    required String projectId,
  }) {
    return local.projectDetailLocal.task.watchTask(projectId: projectId).map((
      event,
    ) {
      final data = helper.collectDataLocal(fetchResult: event);
      final collectorMessage = messageCollector.getMessage(data);
      devLog("Log ProjectDetailRepositoryImp: watchTask: data: $data");
      return (data, collectorMessage);
    });
  }

  void dispose() {
    if (taskChannel != null) {
      remote.projectDetailRemote.task.removeTaskChannel(taskChannel!);
      taskChannel = null;
    }
  }
}
