import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/main_menu/data/repository_imp.dart';
import 'package:task_manager/feature/main_menu/logic/main_menu_event.dart';
import 'package:task_manager/feature/main_menu/logic/main_menu_state.dart';

class MainMenuBloc extends Bloc<MainMenuEvent, MainMenuState> {
  MainMenuBloc() : super(MainMenuInitial()) {
    on<MainMenuGetData>(_getData);
  }

  Future<void> _getData(
    MainMenuGetData event,
    Emitter<MainMenuState> emit,
  ) async {
    final currentState = state is MainMenuLoaded
        ? state as MainMenuLoaded
        : MainMenuLoaded();

    final dataProject = await mainMenuGetProject();
    emit(currentState.copyWith(dataProject: dataProject));
  }
}
