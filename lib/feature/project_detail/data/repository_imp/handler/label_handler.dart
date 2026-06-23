// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class LabelHandler {
  final String companyId;
  final LocalServices local;
  final RemoteServices remote;
  final CollectorMessage messageCollector;
  final CollectData helper;

  LabelHandler({
    required this.companyId,
    required this.local,
    required this.remote,
    required this.messageCollector,
    required this.helper,
  });

  RealtimeChannel? labelChannel;

  Future<void> initLabelRealtime() async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .projectDetailRemote
          .label
          .getAllLabel(companyId: companyId);
      await local.projectDetailLocal.label.syncLabel(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log ProjectDetailRepositoryImp: initLabelRealtime: error: $e");
    }

    if (labelChannel != null) {
      remote.projectDetailRemote.label.removeLabelChannel(labelChannel!);
    }
    labelChannel = remote.projectDetailRemote.label.buildLabelChannel(
      companyId,
    );

    labelChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.labels.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumLabel.companyId.value,
            value: companyId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.projectDetailLocal.label.deleteLabel(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.projectDetailLocal.label.syncLabel(
                  remoteResults: [data],
                );
              }
            } catch (e) {
              devLog(
                "Log ProjectDetailRepositoryImp: initLabelRealtime: error: $e",
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

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchlabel({
    required String companyId,
  }) {
    return local.projectDetailLocal.label.watchLabel(companyId: companyId).map((
      event,
    ) {
      final data = helper.collectDataLocal(fetchResult: event);
      final collectorMessage = messageCollector.getMessage(data);
      devLog("Log ProjectDetailRepositoryImp: watchlabel: data: $data");
      return (data, collectorMessage);
    });
  }

  void dispose() {
    if (labelChannel != null) {
      remote.projectDetailRemote.label.removeLabelChannel(labelChannel!);
      labelChannel = null;
    }
  }
}
