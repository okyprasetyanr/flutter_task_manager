import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDEtailEvent, ProjectDetailState> {
  final ProjectDetailRepository repo;
  ProjectDetailBloc(this.repo) : super(ProjectDetailInisial()) {
    on<ProjectDetailGetData>(_getData);
  }

  Future<void> _getData(
    ProjectDetailGetData event,
    Emitter<ProjectDetailState> emit,
  ) async {
    final currentState = state is ProjectDetailLoaded
        ? state as ProjectDetailLoaded
        : ProjectDetailLoaded();

    final data = await repo.getData();

    emit(
      currentState.copyWith(
        dataMember: data.member,
        dataProject: data.project,
        dataTask: data.task,
      ),
    );
  }
}
