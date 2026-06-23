// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class SubtaskHandler {
  final LocalServices local;
  final RemoteServices remote;
  final CollectorMessage messageCollector;
  final CollectData helper;

  SubtaskHandler({
    required this.local,
    required this.remote,
    required this.messageCollector,
    required this.helper,
  });

  RealtimeChannel? subTaskChannel;
  Future<void> initSubTaskRealtime({required String projectId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .projectDetailRemote
          .subtask
          .getAllSubTask(projectId: projectId);
      devLog(
        "Log ProjectDetailRepositoryImp: initSubTaskRealtime: init: $rawRemoteData",
      );
      await local.projectDetailLocal.subtask.syncSubTask(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log ProjectDetailRepositoryImp: initSubTaskRealtime: error: $e");
    }

    if (subTaskChannel != null) {
      remote.projectDetailRemote.subtask.removeSubTaskChannel(subTaskChannel!);
    }
    subTaskChannel = remote.projectDetailRemote.subtask.buildSubTaskChannel(
      projectId,
    );

    subTaskChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.subtasks.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumSubTask.projectId.value,
            value: projectId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.projectDetailLocal.subtask.deleteSubTask(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.projectDetailLocal.subtask.syncSubTask(
                  remoteResults: [data],
                );
              }
            } catch (e) {
              devLog(
                "Log ProjectDetailRepositoryImp: initSubTaskRealtime: error: $e",
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

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchSubTask({
    required String projectId,
  }) {
    return local.projectDetailLocal.subtask
        .watchSubTask(projectId: projectId)
        .map((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          final collectorMessage = messageCollector.getMessage(data);
          devLog("Log ProjectDetailRepositoryImp: watchSubTask: data: $data");
          return (data, collectorMessage);
        });
  }

  void dispose() {
    if (subTaskChannel != null) {
      remote.projectDetailRemote.subtask.removeSubTaskChannel(subTaskChannel!);
      subTaskChannel = null;
    }
  }
}
