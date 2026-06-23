import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class TaskLabelHandler {
  final LocalServices local;
  final RemoteServices remote;
  final CollectorMessage messageCollector;
  final CollectData helper;

  TaskLabelHandler({
    required this.local,
    required this.remote,
    required this.messageCollector,
    required this.helper,
  });

  RealtimeChannel? taskLabelChannel;

  Future<void> initTaskLabelRealtime({required String projectId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .projectDetailRemote
          .taskLabel
          .getAllTaskLabel(projectId: projectId);
      await local.projectDetailLocal.taskLabel.syncTaskLabel(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog(
        "Log ProjectDetailRepositoryImp: initTaskLabelRealtime: error: $e",
      );
    }

    if (taskLabelChannel != null) {
      remote.projectDetailRemote.taskLabel.removeTaskLabelChannel(
        taskLabelChannel!,
      );
    }
    taskLabelChannel = remote.projectDetailRemote.taskLabel
        .buildTaskLabelChannel(projectId);

    taskLabelChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.taskLabels.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumTaskLabel.projectId.value,
            value: projectId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.projectDetailLocal.taskLabel.deleteTaskLabel(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.projectDetailLocal.taskLabel.syncTaskLabel(
                  remoteResults: [data],
                );
              }
            } catch (e) {
              devLog(
                "Log ProjectDetailRepositoryImp: initTaskLabelRealtime: error: $e",
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

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchTaskLabel({
    required String projectId,
  }) {
    return local.projectDetailLocal.taskLabel
        .watchTaskLabel(projectId: projectId)
        .map((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          final collectorMessage = messageCollector.getMessage(data);
          devLog(
            "Log ProjectDetailRepositoryImp: watchTaskLabel: data: $data, id: $projectId",
          );
          return (data, collectorMessage);
        });
  }

  void dispose() {
    if (taskLabelChannel != null) {
      remote.projectDetailRemote.taskLabel.removeTaskLabelChannel(
        taskLabelChannel!,
      );
      taskLabelChannel = null;
    }
  }
}
