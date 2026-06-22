// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/model/model_label.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/model/model_task.dart';
import 'package:task_manager/shared/model/model_task_labels.dart';

class ProjectDetailRepositoryImp implements ProjectDetailRepository {
  final RemoteServices remote;
  final LocalServices local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserRepository userRepo;

  ProjectDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userRepo,
  });

  RealtimeChannel? taskChannel;
  RealtimeChannel? taskLabelChannel;
  RealtimeChannel? subTaskChannel;
  RealtimeChannel? labekChannel;

  @override
  void disposeRealtime() {
    if (taskChannel != null) {
      remote.projectDetailRemote.removeTaskChannel(taskChannel!);
      taskChannel = null;
    }
    if (taskLabelChannel != null) {
      remote.projectDetailRemote.removeTaskLabelChannel(taskLabelChannel!);
      taskLabelChannel = null;
    }
    if (subTaskChannel != null) {
      remote.projectDetailRemote.removeSubTaskChannel(subTaskChannel!);
      subTaskChannel = null;
    }
    if (labekChannel != null) {
      remote.projectDetailRemote.removeLabelChannel(labekChannel!);
      labekChannel = null;
    }
  }

  @override
  Future<void> initTaskRealtime({required String projectId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .projectDetailRemote
          .getAllTask(projectId: projectId);
      await local.projectDetailLocal.syncTask(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog(
        "Log ProjectDetailRepositoryImp: initTaskRealtime: init: error: $e",
      );
    }

    if (taskChannel != null) {
      remote.projectDetailRemote.removeTaskChannel(taskChannel!);
    }
    taskChannel = remote.projectDetailRemote.buildTaskChannel(projectId);

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
                  await local.projectDetailLocal.deleteTask(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.projectDetailLocal.syncTask(remoteResults: [data]);
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

  @override
  Future<void> initSubTaskRealtime({required String projectId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .projectDetailRemote
          .getAllSubTask(projectId: projectId);
      devLog(
        "Log ProjectDetailRepositoryImp: initSubTaskRealtime: init: $rawRemoteData",
      );
      await local.projectDetailLocal.syncSubTask(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log ProjectDetailRepositoryImp: initSubTaskRealtime: error: $e");
    }

    if (subTaskChannel != null) {
      remote.projectDetailRemote.removeSubTaskChannel(subTaskChannel!);
    }
    taskChannel = remote.projectDetailRemote.buildSubTaskChannel(projectId);

    taskChannel!
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
                  await local.projectDetailLocal.deleteSubTask(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.projectDetailLocal.syncSubTask(
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

  @override
  Future<void> initTaskLabelRealtime({required String projectId}) async {
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .projectDetailRemote
          .getAllTaskLabel(projectId: projectId);
      await local.projectDetailLocal.syncTaskLabel(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog(
        "Log ProjectDetailRepositoryImp: initTaskLabelRealtime: error: $e",
      );
    }

    if (taskLabelChannel != null) {
      remote.projectDetailRemote.removeTaskLabelChannel(taskLabelChannel!);
    }
    taskLabelChannel = remote.projectDetailRemote.buildTaskLabelChannel(
      projectId,
    );

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
                  await local.projectDetailLocal.deleteTaskLabel(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.projectDetailLocal.syncTaskLabel(
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

  @override
  Future<void> initLabelRealtime() async {
    final companyId = userSession.getCompanyId();
    try {
      final List<Map<String, dynamic>> rawRemoteData = await remote
          .projectDetailRemote
          .getAllLabel(companyId: companyId);
      await local.projectDetailLocal.syncLabel(
        remoteResults: rawRemoteData,
        init: true,
      );
    } catch (e) {
      devLog("Log ProjectDetailRepositoryImp: initLabelRealtime: error: $e");
    }

    if (labekChannel != null) {
      remote.projectDetailRemote.removeLabelChannel(labekChannel!);
    }
    labekChannel = remote.projectDetailRemote.buildLabelChannel(companyId);

    labekChannel!
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
                  await local.projectDetailLocal.deleteLabel(
                    deleteId.toString(),
                  );
                }
              } else {
                final data = payload.newRecord;
                await local.projectDetailLocal.syncLabel(remoteResults: [data]);
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

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchTask({
    required String projectId,
  }) {
    return local.projectDetailLocal.watchTask(projectId: projectId).map((
      event,
    ) {
      final data = helper.collectDataLocal(fetchResult: event);
      final collectorMessage = messageCollector.getMessage(data);
      devLog("Log ProjectDetailRepositoryImp: watchTask: data: $data");
      return (data, collectorMessage);
    });
  }

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchTaskLabel({
    required String projectId,
  }) {
    return local.projectDetailLocal.watchTaskLabel(projectId: projectId).map((
      event,
    ) {
      final data = helper.collectDataLocal(fetchResult: event);
      final collectorMessage = messageCollector.getMessage(data);
      devLog(
        "Log ProjectDetailRepositoryImp: watchTaskLabel: data: $data, id: $projectId",
      );
      return (data, collectorMessage);
    });
  }

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchSubTask({
    required String projectId,
  }) {
    return local.projectDetailLocal.watchSubTask(projectId: projectId).map((
      event,
    ) {
      final data = helper.collectDataLocal(fetchResult: event);
      final collectorMessage = messageCollector.getMessage(data);
      devLog("Log ProjectDetailRepositoryImp: watchSubTask: data: $data");
      return (data, collectorMessage);
    });
  }

  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchlabel({
    required String companyId,
  }) {
    return local.projectDetailLocal
        .watchLabel(companyId: userSession.getCompanyId())
        .map((event) {
          final data = helper.collectDataLocal(fetchResult: event);
          final collectorMessage = messageCollector.getMessage(data);
          devLog("Log ProjectDetailRepositoryImp: watchlabel: data: $data");
          return (data, collectorMessage);
        });
  }

  Stream<Set<ModelUser>> watchUser() {
    return userRepo.getUser();
  }

  @override
  Stream<ProjectDetailStateLoaded> watchDashboard({
    required ModelProjectMerge project,
  }) {
    return Rx.combineLatest5(
      userRepo.getUser(),
      watchTask(projectId: project.dataProject.id),
      watchTaskLabel(projectId: project.dataProject.id),
      watchSubTask(projectId: project.dataProject.id),
      watchlabel(companyId: userSession.getCompanyId()),
      (a, b, c, d, e) {
        try {
          final rawTasks =
              b.$1[EnumFetchApiStatus.success] as Iterable? ?? const [];
          final rawLabels =
              c.$1[EnumFetchApiStatus.success] as Iterable? ?? const [];
          final rawSubTasks =
              d.$1[EnumFetchApiStatus.success] as Iterable? ?? const [];
          final rawLabel =
              e.$1[EnumFetchApiStatus.success] as Iterable? ?? const [];

          final dataTaskLabel = rawLabels
              .map((e) => ModelTaskLabels.fromDrift(e))
              .toSet();
          final dataSubTask = rawSubTasks
              .map((e) => ModelSubTask.fromDrift(e))
              .toSet();
          final dataLabel = rawLabel
              .map((e) => ModelLabel.fromDrift(e))
              .toSet();

          final mergedTasks = rawTasks.map((e) {
            final task = ModelTask.fromDrift(e);

            final taskLabel = dataTaskLabel
                .where((element) => element.taskId == task.id)
                .toSet();
            final subTask = dataSubTask
                .where((element) => element.taskId == task.id)
                .toSet();

            return ModelTaskMerge(
              dataTask: task,
              dataSubTask: subTask,
              dataTaskLabel: taskLabel,
            );
          }).toSet();

          return ProjectDetailStateLoaded(
            dataUser: a,
            dataLabel: dataLabel,
            dataProject: project,
            dataTask: mergedTasks,
            status: EnumStatusState.none,
            error: b.$2.error ?? c.$2.error ?? d.$2.error,
            failed: b.$2.failed ?? c.$2.failed ?? d.$2.failed,
          );
        } catch (e) {
          devLog(
            "Log ProjectDEtailRepositoryImp: watchDashboard: error: ${e.toString()}",
          );
        }
        return ProjectDetailStateLoaded();
      },
    );
  }
}
