import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/main_menu/logic/bloc/main_menu_bloc.dart';
import 'package:task_manager/feature/main_menu/logic/bloc/main_menu_event.dart';
import 'package:task_manager/feature/main_menu/presentation/page/ui_main_menu.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainMenuBloc()..add(MainMenuGetData()),
      child: UiMainMenu(),
    );
  }
}
