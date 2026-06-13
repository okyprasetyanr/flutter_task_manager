import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/core/services/api_service/api_services.dart';
import 'package:task_manager/core/services/connection_service/connection_service.dart';
import 'package:task_manager/core/services/connection_service/connection_service_imp.dart';
import 'package:task_manager/core/services/local_service/local_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/shared_component/notification/data/local/notification_local.dart';
import 'package:task_manager/feature/shared_component/notification/data/remote/notification_remote.dart';
import 'package:task_manager/feature/shared_component/notification/data/repository_imp/notification_repository_imp.dart';
import 'package:task_manager/feature/shared_component/notification/domain/repository/notification_repository.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_bloc.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserCache(user: const [])),
        RepositoryProvider(lazy: false, create: (context) => UserSession()),
        RepositoryProvider(lazy: false, create: (context) => LocalServices()),
        RepositoryProvider(lazy: false, create: (context) => ApiServices()),
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
              apiServices: context.read<ApiServices>(),
            ),
            local: NotificationLocal(),
            userSession: context.read<UserSession>(),
            helper: context.read<CollectData>(),
            messageCollector: context.read<CollectorMessage>(),
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
