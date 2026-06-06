import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/services/api_service/api_services.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/login/data/local/login_local.dart';
import 'package:task_manager/feature/login/data/remote/login_remote.dart';
import 'package:task_manager/feature/login/data/repository_imp/login_repository_imp.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/feature/login/presentation/page/login_page.dart';
import 'package:task_manager/feature/workspace/data/local/workspace_local.dart';
import 'package:task_manager/feature/workspace/data/remote/workspace_remote.dart';
import 'package:task_manager/feature/workspace/data/repository_imp/workspace_repository_imp.dart';
import 'package:task_manager/feature/workspace/domain/enum/workspace_enum_status_bloc.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/page/workspace_page.dart';
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';

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
          remote: WorkspaceRemote(apiServices: context.read<ApiServices>()),
          local: WorkspaceLocal(localService: context.read<LocalService>()),
          userSession: context.read<UserSession>(),
          helper: context.read<HelperCollectData>(),
        ),
        child: BlocProvider(
          create: (context) =>
              WorkspaceBloc(context.read<WorkspaceRepository>())..add(
                WorkspaceEventGetData(status: WorkspaceEnumStatusBloc.loading),
              ),
          child: WorkspacePage(),
        ),
      ),
};
