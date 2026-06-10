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
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserCache(user: [])),
        RepositoryProvider(create: (context) => UserSession()),
        RepositoryProvider(create: (context) => LocalServices()),
        RepositoryProvider(create: (context) => ApiServices()),
        RepositoryProvider(create: (context) => ModelMessageCollector()),
        RepositoryProvider<ConnectionService>(
          lazy: false,
          create: (context) => ConnectionServiceImpl(),
        ),
        RepositoryProvider(
          lazy: false,
          create: (context) =>
              HelperCollectData(connection: context.read<ConnectionService>()),
        ),
      ],
      child: MaterialApp(home: MainApp(), debugShowCheckedModeBanner: false),
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
