import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/main_menu/domain/repository/repository.dart';
import 'package:task_manager/feature/main_menu/presentation/bloc/main_menu_event.dart';
import 'package:task_manager/feature/main_menu/presentation/bloc/main_menu_state.dart';

class MainMenuBloc extends Bloc<MainMenuEvent, MainMenuState> {
  final RepositoryWorkSpace repo;
  MainMenuBloc(this.repo) : super(MainMenuInitial()) {
    on<MainMenuGetData>(_getData);
  }

  Future<void> _getData(
    MainMenuGetData event,
    Emitter<MainMenuState> emit,
  ) async {
    final currentState = state is MainMenuLoaded
        ? state as MainMenuLoaded
        : MainMenuLoaded();

    final dataProject = await repo.getProject();
    emit(currentState.copyWith(dataProject: dataProject));
  }
}
