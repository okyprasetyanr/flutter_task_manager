import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/services/api_services.dart';
import 'package:task_manager/core/services/connection_service.dart';
import 'package:task_manager/core/services/implementation/connection_imp.dart';
import 'package:task_manager/feature/login/data/remote/login_remote.dart';
import 'package:task_manager/feature/login/data/repository_imp/login_repository_imp.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/feature/login/presentation/page/login_page.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ApiServices()),
        RepositoryProvider<ConnectionService>(
          create: (context) => ConnectionServiceImpl(),
        ),
      ],
      child: MaterialApp(home: MainApp(), debugShowCheckedModeBanner: false),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<LoginRepository>(
      create: (context) => LoginRepositoryImp(
        connection: context.read<ConnectionService>(),
        remote: LoginRemote(apiService: context.read<ApiServices>()),
      ),
      child: BlocProvider(
        create: (context) => LoginBloc(context.read<LoginRepository>()),
        child: LoginPage(),
      ),
    );
  }
}
