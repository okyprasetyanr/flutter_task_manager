import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/activity/data/local/activity_local.dart';
import 'package:task_manager/feature/activity/data/remote/activity_remote.dart';
import 'package:task_manager/feature/activity/data/repository_imp/activity_repository_imp.dart';
import 'package:task_manager/feature/activity/domain/repository/activity_repository.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_bloc.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_event.dart';
import 'package:task_manager/feature/activity/presentation/page/activity_page.dart';
import 'package:task_manager/feature/history_task/data/local/history_task_local.dart';
import 'package:task_manager/feature/history_task/data/remote/history_task_remote.dart';
import 'package:task_manager/feature/history_task/data/repository_imp/history_task_repository_imp.dart';
import 'package:task_manager/feature/history_task/domain/repository/history_task_repository.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_bloc.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_event.dart';
import 'package:task_manager/feature/history_task/presentation/page/history_task_page.dart';
import 'package:task_manager/feature/project_detail/data/local/project_detail_local.dart';
import 'package:task_manager/feature/project_detail/data/remote/project_detail_remote.dart';
import 'package:task_manager/feature/project_detail/data/repository_imp/project_detail_repository_imp.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/page/project_detail_page.dart';
import 'package:task_manager/feature/task_detail/data/local/task_detail_local.dart';
import 'package:task_manager/feature/task_detail/data/remote/task_detail_remote.dart';
import 'package:task_manager/feature/task_detail/data/repository_imp/task_detail_repository_imp.dart';
import 'package:task_manager/feature/task_detail/domain/repository/task_detail_repository.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/page/task_detail_page.dart';
import 'package:task_manager/feature/workspace_detail/data/local/workspace_detail_local.dart';
import 'package:task_manager/feature/workspace_detail/data/remote/workspace_detail_remote.dart';
import 'package:task_manager/feature/workspace_detail/data/repository_imp/workspace_detail_repository_imp.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/page/workspace_detail_page.dart';
import 'package:task_manager/feature/login/data/local/login_local.dart';
import 'package:task_manager/feature/login/data/remote/login_remote.dart';
import 'package:task_manager/feature/login/data/repository_imp/login_repository_imp.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/feature/login/presentation/page/login_page.dart';
import 'package:task_manager/feature/workspace/data/local/workspace_local.dart';
import 'package:task_manager/feature/workspace/data/remote/workspace_remote.dart';
import 'package:task_manager/feature/workspace/data/repository_imp/workspace_repository_imp.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/page/workspace_page.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/model/model_project.dart';
import 'package:task_manager/shared/model/model_task.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

final routes = {
  '/${RoutesEnum.login}': (context) => RepositoryProvider<LoginRepository>(
    create: (context) => LoginRepositoryImp(
      userSession: context.read<UserSession>(),
      helper: context.read<CollectData>(),
      remote: LoginRemote(apiService: context.read<RemoteService>()),
      local: LoginLocal(localService: context.read<LocalServices>()),
    ),

    child: BlocProvider(
      create: (context) => LoginBloc(context.read<LoginRepository>()),

      child: LoginPage(),
    ),
  ),
  '/${RoutesEnum.workspace}': (context) =>
      RepositoryProvider<WorkspaceRepository>(
        create: (context) => WorkspaceRepositoryImp(
          messageCollector: context.read<CollectorMessage>(),
          remote: WorkspaceRemote(apiServices: context.read<RemoteService>()),
          local: WorkspaceLocal(localService: context.read<LocalServices>()),
          userSession: context.read<UserSession>(),
          helper: context.read<CollectData>(),
        ),

        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  WorkspaceBloc(context.read<WorkspaceRepository>())
                    ..add(WorkspaceEventGetData()),
            ),
          ],
          child: WorkspacePage(),
        ),
      ),
  '/${RoutesEnum.workspaceDetail}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelWorkspace;
    return RepositoryProvider<WorkspaceDetailRepository>(
      create: (context) => WorkspaceDetailRepositoryImp(
        userCache: context.read<UserCache>(),
        remote: WorkspaceDetailRemote(
          apiServices: context.read<RemoteService>(),
        ),
        local: WorkspaceDetailLocal(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
      ),
      child: BlocProvider(
        create: (context) =>
            WorkspaceDetailBloc(context.read<WorkspaceDetailRepository>())
              ..add(WorkspaceDetailEventGetData(data: data)),
        child: WorkspaceDetailPage(),
      ),
    );
  },
  '/${RoutesEnum.projectDetail}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelProject;
    devLog("Log Routes: ArgumentData: ProjectDetail: $data");
    return RepositoryProvider<ProjectDetailRepository>(
      create: (context) => ProjectDetailRepositoryImp(
        remote: ProjectDetailRemote(apiServices: context.read<RemoteService>()),
        local: ProjectDetailLocal(localService: context.read<LocalServices>()),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
      ),
      child: BlocProvider(
        create: (context) =>
            ProjectDetailBloc(context.read<ProjectDetailRepository>())
              ..add(ProjectDetailEventGetData(data: data)),
        child: ProjectDetailPage(),
      ),
    );
  },
  '/${RoutesEnum.historyTask}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelWorkspace;
    return RepositoryProvider<HistoryTaskRepository>(
      create: (context) => HistoryTaskRepositoryImp(
        userCache: context.read<UserCache>(),
        remote: HistoryTaskRemote(apiServices: context.read<RemoteService>()),
        local: HistoryTaskLocal(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
      ),
      child: BlocProvider(
        create: (context) =>
            HistoryTaskBloc(context.read<HistoryTaskRepository>())
              ..add(HistoryTaskEventGetData(data: data)),
        child: HistoryTaskPage(),
      ),
    );
  },
  '/${RoutesEnum.taskDetail}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelTask;

    return RepositoryProvider<TaskDetailRepository>(
      create: (context) => TaskDetailRepositoryImp(
        remote: TaskDetailRemote(apiServices: context.read<RemoteService>()),
        local: TaskDetailLocal(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
        userCache: context.read<UserCache>(),
      ),
      child: BlocProvider(
        create: (context) =>
            TaskDetailBloc(context.read<TaskDetailRepository>())
              ..add(TaskDetailEventGetData(dataTask: data)),
        child: TaskDetailPage(),
      ),
    );
  },
  '/${RoutesEnum.activity}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelWorkspace;
    return RepositoryProvider<ActivityRepository>(
      create: (context) => ActivityRepositoryImp(
        userCache: context.read<UserCache>(),
        remote: ActivityRemote(apiServices: context.read<RemoteService>()),
        local: ActivityLocal(),
        userSession: context.read<UserSession>(),
        helper: context.read<CollectData>(),
        messageCollector: context.read<CollectorMessage>(),
      ),
      child: BlocProvider(
        create: (context) =>
            ActivityBloc(context.read<ActivityRepository>())
              ..add(ActivityEventGetData(data: data)),
        child: ActivityPage(),
      ),
    );
  },
};
