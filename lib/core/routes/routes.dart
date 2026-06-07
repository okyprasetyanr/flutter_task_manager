import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/services/api_service/api_services.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
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
import 'package:task_manager/shared/model/model_workspace.dart';

final routes = {
  '/${RoutesEnum.login}': (context) => RepositoryProvider<LoginRepository>(
    create: (context) => LoginRepositoryImp(
      userSession: context.read<UserSession>(),
      helper: context.read<HelperCollectData>(),
      remote: LoginRemote(apiService: context.read<ApiServices>()),
      local: LoginLocal(localService: context.read<LocalService>()),
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
          local: WorkspaceLocal(localService: context.read<LocalService>()),
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
  '/${RoutesEnum.workspacedetail}': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final dataWorkspace = args!['dataWorkspace'] as ModelWorkspace;
    devLog("Log Routes: ArgumentData: WorkspaceDetail: $dataWorkspace");
    return RepositoryProvider<WorkspaceDetailRepository>(
      create: (context) => WorkspaceDetailRepositoryImp(
        remote: WorkspaceDetailRemote(apiServices: context.read<ApiServices>()),
        local: WorkspaceDetailLocal(),
        userSession: context.read<UserSession>(),
        helper: context.read<HelperCollectData>(),
        messageCollector: context.read<ModelMessageCollector>(),
      ),
      child: BlocProvider(
        create: (context) =>
            WorkspaceDetailBloc(context.read<WorkspaceDetailRepository>())
              ..add(WorkspaceDetailEventGetData(data: dataWorkspace)),
        child: WorkspaceDetailPage(),
      ),
    );
  },
};
