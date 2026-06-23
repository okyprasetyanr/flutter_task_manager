// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/task_detail/domain/repository/task_detail_repository.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/model/model_comment.dart';
import 'package:task_manager/shared/model/model_label.dart';

class TaskDetailRepositoryImp implements TaskDetailRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserRepository userRepo;
  TaskDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userRepo,
  });

  RealtimeChannel? commentChannel;

  @override
  void disposeRealtime() {
    if (commentChannel != null) {
      commentChannel = null;
    }
  }

  @override
  Future<void> initCommentRealtime({required String taskId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .taskDetailRemote
          .getAllComment(companyId: taskId);
      devLog("Log TaskDetailRepositoryImp: Init: data: $rawRemoteData");
      await local.taskDetailLocal.syncComment(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log TaskDetailRepositoryImp: error: $e");
    }

    if (commentChannel != null) {
      remote.taskDetailRemote.removeCommentChannel(commentChannel!);
    }
    commentChannel = remote.taskDetailRemote.buildCommentChannel(taskId);

    commentChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: EnumTable.comments.value,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: EnumComment.taskId.value,
            value: taskId,
          ),
          callback: (PostgresChangePayload payload) async {
            try {
              if (payload.eventType == PostgresChangeEvent.delete) {
                final deleteId = payload.oldRecord['id'];

                if (deleteId != null) {
                  await local.taskDetailLocal.deleteComment(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.taskDetailLocal.syncComment(remoteResults: [data]);
              }
            } catch (e) {
              devLog("Log TaskDetailRepositoryImp: error: $e");
            }
          },
        )
        .subscribe((state, error) {
          if (error != null) {
            devLog("Log TaskDetailRepositoryImp: error Supabase: $error");
          }
        });
  }

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchComment({
    required String taskId,
  }) {
    return local.taskDetailLocal.watchComment(taskId: taskId).map((event) {
      final data = helper.collectDataLocal(fetchResult: event);
      final collectorMessage = messageCollector.getMessage(data);
      devLog("Log TaskDetailRepositoryImp: data: $data");
      return (data, collectorMessage);
    });
  }

  Stream<Set<ModelUser>> watchUser() {
    return userRepo.getUser();
  }

  @override
  Stream<TaskDetailStateLoaded> watchDashboard({
    required ModelTaskMerge task,
    required Set<ModelLabel> label,
  }) {
    return Rx.combineLatest2(
      watchUser(),
      watchComment(taskId: task.dataTask.id),
      (a, b) {
        final comment = (b.$1[EnumFetchApiStatus.success] as List)
            .map((e) => ModelComment.fromDrift(e))
            .toSet();

        final labelIds = task.dataTaskLabel.map((e) => e.labelId).toSet();

        final filteredLabel = label
            .where((e) => labelIds.contains(e.id))
            .toSet();

        return TaskDetailStateLoaded(
          dataLabel: filteredLabel,
          dataUser: a,
          task: task,
          dataComment: comment,
          status: EnumStatusState.none,
          error: b.$2.error,
          failed: b.$2.failed,
        );
      },
    );
  }
}
