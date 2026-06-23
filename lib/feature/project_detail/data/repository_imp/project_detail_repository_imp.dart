// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/project_detail/data/repository_imp/handler/label_handler.dart';
import 'package:task_manager/feature/project_detail/data/repository_imp/handler/subtask_handler.dart';
import 'package:task_manager/feature/project_detail/data/repository_imp/handler/task_label_handler.dart';
import 'package:task_manager/feature/project_detail/data/repository_imp/handler/task_handler.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_labels.dart';

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
  RealtimeChannel? labelChannel;

  late SubtaskHandler subTaskHandler;
  late TaskHandler taskHandler;
  late TaskLabelHandler taskLabelHandler;
  late LabelHandler labelHandler;

  @override
  void disposeRealtime() {
    subTaskHandler.dispose();
    taskHandler.dispose();
    taskLabelHandler.dispose();
    labelHandler.dispose();
  }

  @override
  Future<void> initTaskRealtime({required String projectId}) async {
    taskHandler = TaskHandler(
      local: local,
      remote: remote,
      messageCollector: messageCollector,
      helper: helper,
    );

    taskHandler.initTaskRealtime(projectId: projectId);
  }

  @override
  Future<void> initSubTaskRealtime({required String projectId}) async {
    subTaskHandler = SubtaskHandler(
      local: local,
      remote: remote,
      messageCollector: messageCollector,
      helper: helper,
    );

    subTaskHandler.initSubTaskRealtime(projectId: projectId);
  }

  @override
  Future<void> initTaskLabelRealtime({required String projectId}) async {
    taskLabelHandler = TaskLabelHandler(
      local: local,
      remote: remote,
      messageCollector: messageCollector,
      helper: helper,
    );

    taskLabelHandler.initTaskLabelRealtime(projectId: projectId);
  }

  @override
  Future<void> initLabelRealtime() async {
    final companyId = userSession.getCompanyId();
    labelHandler = LabelHandler(
      companyId: companyId,
      local: local,
      remote: remote,
      messageCollector: messageCollector,
      helper: helper,
    );

    labelHandler.initLabelRealtime();
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
      taskHandler.watchTask(projectId: project.dataProject.id),
      taskLabelHandler.watchTaskLabel(projectId: project.dataProject.id),
      subTaskHandler.watchSubTask(projectId: project.dataProject.id),
      labelHandler.watchlabel(companyId: userSession.getCompanyId()),
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
