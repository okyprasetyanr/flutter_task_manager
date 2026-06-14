import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/core/services/connection_service/connection_service.dart';
import 'package:task_manager/core/services/connection_service/connection_service_imp.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/activity/data/remote/activity_remote.dart';
import 'package:task_manager/feature/history_task/data/remote/history_task_remote.dart';
import 'package:task_manager/feature/login/data/remote/login_remote.dart';
import 'package:task_manager/feature/project_detail/data/remote/project_detail_remote.dart';
import 'package:task_manager/feature/shared_component/notification/data/local/notification_local.dart';
import 'package:task_manager/feature/shared_component/notification/data/remote/notification_remote.dart';
import 'package:task_manager/feature/shared_component/notification/data/repository_imp/notification_repository_imp.dart';
import 'package:task_manager/feature/shared_component/notification/domain/repository/notification_repository.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_bloc.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/task_detail/data/remote/task_detail_remote.dart';
import 'package:task_manager/feature/workspace/data/remote/workspace_remote.dart';
import 'package:task_manager/feature/workspace_detail/data/remote/workspace_detail_remote.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Supabase secara Global
  await Supabase.initialize(
    url: 'https://sqaaayjctlrdwcviorik.supabase.co/rest/v1/',
    publishableKey: 'sb_publishable_ZL5BbfE1aOb5cdJK6bfvBw_s8trWyN-',
  );
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserCache(user: const [])),
        RepositoryProvider(lazy: false, create: (context) => UserSession()),
        RepositoryProvider(lazy: false, create: (context) => LocalServices()),
        RepositoryProvider(lazy: false, create: (context) => ResponseWrapper()),
        RepositoryProvider(create: (context) => CollectorMessage()),
        RepositoryProvider<ConnectionService>(
          lazy: false,
          create: (context) => ConnectionServiceImpl(),
        ),
        RepositoryProvider(
          lazy: false,
          create: (context) =>
              CollectData(connection: context.read<ConnectionService>()),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepositoryImp(
            remote: NotificationRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
            local: NotificationLocal(),
            userSession: context.read<UserSession>(),
            helper: context.read<CollectData>(),
            messageCollector: context.read<CollectorMessage>(),
          ),
        ),

        RepositoryProvider(
          create: (context) => RemoteService(
            workspaceRemote: WorkspaceRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
            workspaceDetailRemote: WorkspaceDetailRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
            loginRemote: LoginRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
            projectDetailRemote: ProjectDetailRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
            historyTaskRemote: HistoryTaskRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
            taskDetailRemote: TaskDetailRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
            activityRemote: ActivityRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
            notificationRemote: NotificationRemote(
              responseWrapper: context.read<ResponseWrapper>(),
            ),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            NotificationBloc(context.read<NotificationRepository>()),
        child: MaterialApp(home: MainApp(), debugShowCheckedModeBanner: false),
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RoutesNavigator(
        context: context,
        routeName: RoutesEnum.login,
        replace: true,
        arguments: null,
      ).navigate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppPropertyColor.white);
  }
}
