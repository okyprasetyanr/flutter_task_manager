import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/activity/domain/model/model_activity.dart';
import 'package:task_manager/feature/activity/domain/repository/activity_repository.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_state.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class ActivityRepositoryImp implements ActivityRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserRepository userRepo;

  ActivityRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userRepo,
  });

  RealtimeChannel? _activityChannel;

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchActivity({
    required String workspaceId,
  }) {
    return local.activityLocal.watchActivity(workspaceId: workspaceId).map((
      event,
    ) {
      final data = helper.collectDataLocal(fetchResult: event);
      return (data, messageCollector.getMessage(data));
    });
  }

  @override
  Future<void> initActivityRealTime({required String workspaceId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .activityRemote
          .getAllActivities(workspaceId: workspaceId);
      await local.activityLocal.syncActivity(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log ActivityRepositoryImp: error: $e");
    }

    if (_activityChannel != null) {
      remote.activityRemote.removeActivityChannel(_activityChannel!);
    }
    _activityChannel = remote.activityRemote.buildActivityChannel(workspaceId);

    _activityChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.activities.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumActivity.workspaceId.value,
            value: workspaceId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType != PostgresChangeEvent.delete) {
                final data = payload.newRecord;
                await local.activityLocal.syncActivity(remoteResults: [data]);
              }
            } catch (e) {
              devLog("Log ActivityRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log ActivityRepositoryImp: error Supabase: $error");
          }
        });
  }

  Stream<Set<ModelUser>> watchUser() {
    devLog("Log UserRepository: getUser: check");
    return userRepo.getUser();
  }

  @override
  Stream<ActivityStateLoaded> watchDashboard({
    required ModelWorkspaceMerge workspace,
  }) {
    return Rx.combineLatest2(
      watchUser(),
      watchActivity(workspaceId: workspace.dataWorkspace.id),
      (a, b) {
        return ActivityStateLoaded(
          dataUser: a,
          workspace: workspace,
          dataActivity: (b.$1[EnumFetchApiStatus.success] as List)
              .map((e) => ModelActivity.fromDrift(e))
              .toSet(),
          error: b.$2.error,
          failed: b.$2.failed,
          status: EnumStatusState.none,
        );
      },
    );
  }

  @override
  void disposeActivityRealtime() {
    if (_activityChannel != null) {
      _activityChannel = null;
    }
  }
}
