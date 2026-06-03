import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/services/api_services.dart';
import 'package:task_manager/feature/main_menu/data/data_resource/local/get_workspace.dart';
import 'package:task_manager/feature/main_menu/data/data_resource/remote/get_workspace.dart';
import 'package:task_manager/feature/main_menu/data/repository_imp/repository_imp.dart';
import 'package:task_manager/feature/main_menu/domain/repository/repository.dart';
import 'package:task_manager/feature/main_menu/presentation/bloc/main_menu_bloc.dart';
import 'package:task_manager/feature/main_menu/presentation/bloc/main_menu_event.dart';
import 'package:task_manager/feature/main_menu/presentation/page/ui_main_menu.dart';

void main() {
  runApp(
    RepositoryProvider(
      create: (context) => ApiServices(),
      child: MaterialApp(home: MainApp(), debugShowCheckedModeBanner: false),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<RepositoryWorkSpace>(
      create: (context) => RepositoryWorkSpaceImp(
        local: LocalMainMenu(),
        remote: RemoteMainMenu(api: context.read<ApiServices>()),
      ),
      child: BlocProvider(
        create: (context) =>
            MainMenuBloc(context.read<RepositoryWorkSpace>())
              ..add(MainMenuGetData()),
        child: UiMainMenu(),
      ),
    );
  }
}
