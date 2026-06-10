import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/services/api_service/api_services.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
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
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';
import 'package:task_manager/shared/model/model_project.dart';
import 'package:task_manager/shared/model/model_user.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

final routes = {
  '/${RoutesEnum.login}': (context) => RepositoryProvider<LoginRepository>(
    create: (context) => LoginRepositoryImp(
      userSession: context.read<UserSession>(),
      helper: context.read<HelperCollectData>(),
      remote: LoginRemote(apiService: context.read<ApiServices>()),
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
          messageCollector: context.read<ModelMessageCollector>(),
          remote: WorkspaceRemote(apiServices: context.read<ApiServices>()),
          local: WorkspaceLocal(localService: context.read<LocalServices>()),
          userSession: context.read<UserSession>(),
          helper: context.read<HelperCollectData>(),
        ),

        child: BlocProvider(
          create: (context) =>
              WorkspaceBloc(context.read<WorkspaceRepository>())
                ..add(WorkspaceEventGetData()),
          child: WorkspacePage(),
        ),
      ),
  '/${RoutesEnum.workspaceDetail}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final data = args!['dataTransfered'] as ModelWorkspace;
    return RepositoryProvider<WorkspaceDetailRepository>(
      create: (context) => WorkspaceDetailRepositoryImp(
        userCache: context.read<UserCache>(),
        remote: WorkspaceDetailRemote(apiServices: context.read<ApiServices>()),
        local: WorkspaceDetailLocal(),
        userSession: context.read<UserSession>(),
        helper: context.read<HelperCollectData>(),
        messageCollector: context.read<ModelMessageCollector>(),
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
        remote: ProjectDetailRemote(apiServices: context.read<ApiServices>()),
        local: ProjectDetailLocal(localService: context.read<LocalServices>()),
        userSession: context.read<UserSession>(),
        helper: context.read<HelperCollectData>(),
        messageCollector: context.read<ModelMessageCollector>(),
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
    final data = args!['dataTransfered'] as (ModelWorkspace, List<ModelUser>);
    return RepositoryProvider<HistoryTaskRepository>(
      create: (context) => HistoryTaskRepositoryImp(
        userCache: context.read<UserCache>(),
        remote: HistoryTaskRemote(apiServices: context.read<ApiServices>()),
        local: HistoryTaskLocal(),
        userSession: context.read<UserSession>(),
        helper: context.read<HelperCollectData>(),
        messageCollector: context.read<ModelMessageCollector>(),
      ),
      child: BlocProvider(
        create: (context) =>
            HistoryTaskBloc(context.read<HistoryTaskRepository>())
              ..add(HistoryTaskEventGetData(data: data.$1, user: data.$2)),
        child: HistoryTaskPage(),
      ),
    );
  },
};
