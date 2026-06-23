import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectDetailRepository repo;
  ProjectDetailBloc(this.repo) : super(ProjectDetailStateInitial()) {
    on<ProjectDetailEventGetData>(_onWatchDashboard);
    on<ProjectDetailEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onWatchDashboard(
    ProjectDetailEventGetData event,
    Emitter<ProjectDetailState> emit,
  ) async {
    add(ProjectDetailEventChangeStatus(status: EnumStatusState.loading));
    final project = event.data!;
    await repo.initTaskRealtime(projectId: project.dataProject.id);
    await repo.initTaskLabelRealtime(projectId: project.dataProject.id);
    await repo.initSubTaskRealtime(projectId: project.dataProject.id);
    await repo.initLabelRealtime();
    await emit.forEach(
      repo.watchDashboard(project: project),
      onData: (data) {
        devLog("Log ProjectDetailBloc: checked");
        return data;
      },
      onError: (error, stackTrace) =>
          (state is ProjectDetailStateLoaded
                  ? state as ProjectDetailStateLoaded
                  : ProjectDetailStateLoaded())
              .copyWith(error: error.toString(), status: EnumStatusState.none),
    );
  }

  FutureOr<void> _onChangeStatus(
    ProjectDetailEventChangeStatus event,
    Emitter<ProjectDetailState> emit,
  ) {
    emit(
      (state is ProjectDetailStateLoaded
              ? state as ProjectDetailStateLoaded
              : ProjectDetailStateLoaded())
          .copyWith(status: event.status),
    );
  }

  @override
  Future<void> close() {
    repo.disposeRealtime();
    return super.close();
  }
}
