import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/root_scaffold_messenger_key/root_scaffold_message_key.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/core/services/connection_service/connection_service.dart';
import 'package:task_manager/core/services/connection_service/connection_service_imp.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_local.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/core/stream_manager/stream_manager.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/activity/data/local/activity_local.dart';
import 'package:task_manager/feature/activity/data/remote/activity_remote.dart';
import 'package:task_manager/feature/history_task/data/local/history_task_local.dart';
import 'package:task_manager/feature/history_task/data/remote/history_task_remote.dart';
import 'package:task_manager/feature/login/data/remote/login_remote.dart';
import 'package:task_manager/feature/project_detail/data/local/project_detail_local.dart';
import 'package:task_manager/feature/project_detail/data/local/source/label_local_source.dart';
import 'package:task_manager/feature/project_detail/data/local/source/subtask_local_source.dart';
import 'package:task_manager/feature/project_detail/data/local/source/task_label_local_source.dart';
import 'package:task_manager/feature/project_detail/data/local/source/task_local_source.dart';
import 'package:task_manager/feature/project_detail/data/remote/project_detail_remote.dart';
import 'package:task_manager/feature/project_detail/data/remote/source/label_remote_source.dart';
import 'package:task_manager/feature/project_detail/data/remote/source/subtask_remote_source.dart';
import 'package:task_manager/feature/project_detail/data/remote/source/task_label_remote_source.dart';
import 'package:task_manager/feature/project_detail/data/remote/source/task_remote_source.dart';
import 'package:task_manager/feature/shared_component/helper/sync_table.dart';
import 'package:task_manager/feature/shared_component/notification/data/remote/notification_remote.dart';
import 'package:task_manager/feature/shared_component/notification/data/repository_imp/notification_repository_imp.dart';
import 'package:task_manager/feature/shared_component/notification/domain/repository/notification_repository.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_bloc.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/user/data/local/user_local.dart';
import 'package:task_manager/feature/shared_component/user/data/remote/user_remote.dart';
import 'package:task_manager/feature/shared_component/user/data/repository_imp/user_repository_imp.dart';
import 'package:task_manager/feature/shared_component/user/domain/repository/user_repository.dart';
import 'package:task_manager/feature/task_detail/data/remote/task_detail_remote.dart';
import 'package:task_manager/feature/workspace/data/local/workspace_local.dart';
import 'package:task_manager/feature/workspace/data/remote/workspace_remote.dart';
import 'package:task_manager/feature/workspace_detail/data/local/workspace_detail_local.dart';
import 'package:task_manager/feature/workspace_detail/data/remote/workspace_detail_remote.dart';
import 'package:task_manager/core/services/local_database/local_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://sqaaayjctlrdwcviorik.supabase.co',
    publishableKey: 'sb_publishable_ZL5BbfE1aOb5cdJK6bfvBw_s8trWyN-',
  );
  final client = Supabase.instance.client;
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserCache()),
        RepositoryProvider(create: (context) => StreamManager()),
        RepositoryProvider(lazy: false, create: (context) => UserSession()),
        RepositoryProvider(
          lazy: false,
          create: (context) => ResponseWrapperRemote(),
        ),
        RepositoryProvider(
          lazy: false,
          create: (context) => ResponseWrapperLocal(),
        ),
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
        RepositoryProvider(lazy: false, create: (context) => LocalDatabase()),
        RepositoryProvider(
          create: (context) =>
              SyncTable(localDatabase: context.read<LocalDatabase>()),
        ),
        RepositoryProvider(
          lazy: false,
          create: (context) {
            final local = context.read<LocalDatabase>();
            final syncTable = context.read<SyncTable>();
            final wrapper = context.read<ResponseWrapperLocal>();
            return LocalServices(
              projectDetailLocal: ProjectDetailLocal(
                label: LabelLocalSource(
                  localDatabase: local,
                  syncTable: syncTable,
                  responseWrapper: wrapper,
                ),
                subtask: SubtaskLocalSource(
                  localDatabase: local,
                  syncTable: syncTable,
                  responseWrapper: wrapper,
                ),
                task: TaskLocalSource(
                  localDatabase: local,
                  syncTable: syncTable,
                  responseWrapper: wrapper,
                ),
                taskLabel: TaskLabelLocalSource(
                  localDatabase: local,
                  syncTable: syncTable,
                  responseWrapper: wrapper,
                ),
              ),
              activityLocal: ActivityLocal(
                localDatabase: local,
                responseWrapper: wrapper,
                syncTable: syncTable,
              ),
              historyTaskLocal: HistoryTaskLocal(
                localDatabase: local,
                responseWrapper: wrapper,
                syncTable: syncTable,
              ),
              workspaceDetailLocal: WorkspaceDetailLocal(
                syncTable: syncTable,
                localDatabase: local,
                responseWrapper: wrapper,
              ),
              userLocal: UserLocal(
                syncTable: syncTable,
                responseWrapper: wrapper,
                localDatabase: local,
              ),
              workspaceLocal: WorkspaceLocal(
                syncTable: syncTable,
                localDatabase: local,
                responseWrapper: wrapper,
              ),
            );
          },
        ),
        RepositoryProvider(
          create: (context) {
            final wrapper = context.read<ResponseWrapperRemote>();
            return RemoteServices(
              userRemote: UserRemote(
                responseWrapper: wrapper,
                supabaseClient: client,
              ),
              workspaceRemote: WorkspaceRemote(
                responseWrapper: wrapper,
                supabaseClient: client,
              ),
              workspaceDetailRemote: WorkspaceDetailRemote(
                supabaseClient: client,
                responseWrapper: wrapper,
              ),
              loginRemote: LoginRemote(responseWrapper: wrapper),
              projectDetailRemote: ProjectDetailRemote(
                label: LabelRemoteSource(
                  responseWrapper: wrapper,
                  supabaseClient: client,
                ),
                subtask: SubtaskRemoteSource(
                  responseWrapper: wrapper,
                  supabaseClient: client,
                ),
                task: TaskRemoteSource(
                  responseWrapper: wrapper,
                  supabaseClient: client,
                ),
                taskLabel: TaskLabelRemoteSource(
                  responseWrapper: wrapper,
                  supabaseClient: client,
                ),
              ),
              historyTaskRemote: HistoryTaskRemote(
                responseWrapper: wrapper,
                supabaseClient: client,
              ),
              taskDetailRemote: TaskDetailRemote(responseWrapper: wrapper),
              activityRemote: ActivityRemote(
                responseWrapper: wrapper,
                supabaseClient: client,
              ),
              notificationRemote: NotificationRemote(
                responseWrapper: wrapper,
                supabaseClient: client,
              ),
            );
          },
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepositoryImp(
            remote: context.read<RemoteServices>(),
            local: context.read<LocalServices>(),
            userSession: context.read<UserSession>(),
            helper: context.read<CollectData>(),
            messageCollector: context.read<CollectorMessage>(),
          ),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepositoryImp(
            streamSubsc: context.read<StreamManager>(),
            remote: context.read<RemoteServices>(),
            local: context.read<LocalServices>(),
            userSession: context.read<UserSession>(),
            helper: context.read<CollectData>(),
            messageCollector: context.read<CollectorMessage>(),
            userCache: context.read<UserCache>(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            NotificationBloc(context.read<NotificationRepository>()),
        child: MaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          home: MainApp(),
          debugShowCheckedModeBanner: false,
        ),
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
