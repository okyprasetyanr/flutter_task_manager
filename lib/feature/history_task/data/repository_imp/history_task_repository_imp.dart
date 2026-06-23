import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/history_task/domain/model/model_task_history.dart';
import 'package:task_manager/feature/history_task/domain/repository/history_task_repository.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_state.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

class HistoryTaskRepositoryImp implements HistoryTaskRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserRepository userRepo;

  HistoryTaskRepositoryImp({
    required this.remote,
    required this.userRepo,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });

  RealtimeChannel? _historyChannel;

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchHisotryTask({required String workspaceId}) {
    return local.historyTaskLocal.watchHistory(workspaceId: workspaceId).map((
      event,
    ) {
      devLog("Log HistoryTaskRepositoryImp: watch: $event");
      final data = helper.collectDataLocal(fetchResult: event);
      return (data, messageCollector.getMessage(data));
    });
  }

  @override
  Future<void> initHistoryRealTime({required String workspaceId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .historyTaskRemote
          .getAllHistories(workspaceId: workspaceId);
      devLog("Log HistoryTaskRepositoryImp: data: $rawRemoteData");
      await local.historyTaskLocal.syncHistory(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log HistoryRepositoryImp: error: $e");
    }

    if (_historyChannel != null) {
      remote.historyTaskRemote.removeHistoryChannel(_historyChannel!);
    }
    _historyChannel = remote.historyTaskRemote.buildHistoryChannel(workspaceId);

    _historyChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.taskHistories.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumHistoryTask.workspaceId.value,
            value: workspaceId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType != PostgresChangeEvent.delete) {
                final data = payload.newRecord;
                await local.historyTaskLocal.syncHistory(remoteResults: [data]);
              }
            } catch (e) {
              devLog("Log HistoryTaskRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log HistoryTaskRepositoryImp: error Supabase: $error");
          }
        });
  }

  @override
  void disposeHistoryRealtime() {
    if (_historyChannel != null) {
      remote.historyTaskRemote.removeHistoryChannel(_historyChannel!);
      _historyChannel = null;
    }
  }

  Stream<Set<ModelUser>> watchUser() {
    devLog("Log UserRepository: getUser: check");
    return userRepo.getUser();
  }

  @override
  Stream<HistoryTaskStateLoaded> watchDashboard({
    required ModelWorkspaceMerge workspace,
  }) {
    return Rx.combineLatest2(
      watchUser(),
      watchHisotryTask(workspaceId: workspace.dataWorkspace.id),
      (a, b) {
        devLog("Log HistoryTaskRepository: watchDashboard: data:$b");
        return HistoryTaskStateLoaded(
          dataUser: a,
          workspace: workspace,
          dataHistoryTask: (b.$1[EnumFetchApiStatus.success] as List)
              .map((e) => ModelHistoryTask.fromDrift(e))
              .toSet(),
          error: b.$2.error,
          failed: b.$2.failed,
          status: EnumStatusState.none,
        );
      },
    );
  }
}
