import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/activity/data/repository_imp/activity_repository_imp.dart';
import 'package:task_manager/feature/activity/domain/repository/activity_repository.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_bloc.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_event.dart';
import 'package:task_manager/feature/activity/presentation/page/activity_page.dart';
import 'package:task_manager/feature/history_task/data/repository_imp/history_task_repository_imp.dart';
import 'package:task_manager/feature/history_task/domain/repository/history_task_repository.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_bloc.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_event.dart';
import 'package:task_manager/feature/history_task/presentation/page/history_task_page.dart';
import 'package:task_manager/feature/project_detail/data/repository_imp/project_detail_repository_imp.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/page/project_detail_page.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/repository/not_log_repository.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/task_detail/data/repository_imp/task_detail_repository_imp.dart';
import 'package:task_manager/feature/task_detail/domain/repository/task_detail_repository.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/page/task_detail_page.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/data/repository_imp/workspace_detail_repository_imp.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/page/workspace_detail_page.dart';
import 'package:task_manager/feature/login/data/local/login_local.dart';
import 'package:task_manager/feature/login/data/repository_imp/login_repository_imp.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/feature/login/presentation/page/login_page.dart';
import 'package:task_manager/feature/workspace/data/repository_imp/workspace_repository_imp.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/page/workspace_page.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';

final statusInit = EnumStatusState.loading;
final routes = {
  '/${RoutesEnum.login}': (context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<LoginRepository>(
        create: (context) => LoginRepositoryImp(
          notLogRepository: context.read<NotLogRepository>(),
          userRepository: context.read<UserRepository>(),
          userSession: context.read<UserSession>(),
          helper: context.read<CollectData>(),
          remote: context.read<RemoteServices>(),
          local: LoginLocal(localService: context.read<LocalServices>()),
        ),
      ),
    ],

    child: BlocProvider(
      create: (context) => LoginBloc(context.read<LoginRepository>()),

      child: LoginPage(),
    ),
  ),
  '/${RoutesEnum.workspace}': (context) =>
      RepositoryProvider<WorkspaceRepository>(
        create: (context) => WorkspaceRepositoryImp(
          userRepo: context.read<UserRepository>(),
          messageCollector: context.read<CollectorMessage>(),
          remote: context.read<RemoteServices>(),
          local: context.read<LocalServices>(),
          userSession: context.read<UserSession>(),
          helper: context.read<CollectData>(),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  WorkspaceBloc(context.read<WorkspaceRepository>())
                    ..add(WorkspaceEventWatch()),
            ),
          ],
          child: WorkspacePage(),
        ),
      ),
  '/${RoutesEnum.workspaceDetail}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelWorkspaceMerge;
    return RepositoryProvider<WorkspaceDetailRepository>(
      create: (context) => WorkspaceDetailRepositoryImp(
        userRepo: context.read<UserRepository>(),
        remote: context.read<RemoteServices>(),
        local: context.read<LocalServices>(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
      ),
      child: BlocProvider(
        create: (context) =>
            WorkspaceDetailBloc(context.read<WorkspaceDetailRepository>())
              ..add(WorkspaceDetailEventWatch(data: data)),
        child: WorkspaceDetailPage(),
      ),
    );
  },
  '/${RoutesEnum.projectDetail}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelProjectMerge;
    devLog("Log Routes: ArgumentData: ProjectDetail: $data");
    return RepositoryProvider<ProjectDetailRepository>(
      create: (context) => ProjectDetailRepositoryImp(
        userRepo: context.read<UserRepository>(),
        remote: context.read<RemoteServices>(),
        local: context.read<LocalServices>(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
      ),
      child: BlocProvider(
        create: (context) =>
            ProjectDetailBloc(context.read<ProjectDetailRepository>())
              ..add(ProjectDetailEventWatch(data: data)),
        child: ProjectDetailPage(),
      ),
    );
  },
  '/${RoutesEnum.historyTask}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelWorkspaceMerge;
    return RepositoryProvider<HistoryTaskRepository>(
      create: (context) => HistoryTaskRepositoryImp(
        userRepo: context.read<UserRepository>(),
        remote: context.read<RemoteServices>(),
        local: context.read<LocalServices>(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
      ),
      child: BlocProvider(
        create: (context) =>
            HistoryTaskBloc(context.read<HistoryTaskRepository>())
              ..add(HistoryTaskEventWatchHistory(data: data)),
        child: HistoryTaskPage(),
      ),
    );
  },
  '/${RoutesEnum.taskDetail}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as (ModelTaskMerge, Set<ModelLabel>);

    return RepositoryProvider<TaskDetailRepository>(
      create: (context) => TaskDetailRepositoryImp(
        remote: context.read<RemoteServices>(),
        local: context.read<LocalServices>(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
        userRepo: context.read<UserRepository>(),
      ),
      child: BlocProvider(
        create: (context) =>
            TaskDetailBloc(context.read<TaskDetailRepository>())..add(
              TaskDetailEventWatchDashboard(
                dataTask: data.$1,
                dataLabel: data.$2,
              ),
            ),
        child: TaskDetailPage(),
      ),
    );
  },
  '/${RoutesEnum.activity}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelWorkspaceMerge;
    return RepositoryProvider<ActivityRepository>(
      create: (context) => ActivityRepositoryImp(
        userRepo: context.read<UserRepository>(),
        remote: context.read<RemoteServices>(),
        local: context.read<LocalServices>(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
      ),
      child: BlocProvider(
        create: (context) =>
            ActivityBloc(context.read<ActivityRepository>())
              ..add(ActivityEventWatchActivity(data: data)),
        child: ActivityPage(),
      ),
    );
  },
};
