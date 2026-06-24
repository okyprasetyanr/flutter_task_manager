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
    on<ProjectDetailEventWatch>(_onWatchDashboard);
    on<ProjectDetailEventChangeStatus>(_onChangeStatus);
    on<ProjectDetailEventSelectedData>(_onSelectedData);
    on<ProjectDetailEventResetSelected>(_onResetSelected);
    on<ProjectDetailEventUpdateTask>(_onUpdateTask);
    on<ProjectDetailEventCreateTask>(_onCreateTask);
    on<ProjectDetailEventDeleteTask>(_onDeleteTask);
  }

  Future<void> _onWatchDashboard(
    ProjectDetailEventWatch event,
    Emitter<ProjectDetailState> emit,
  ) async {
    add(ProjectDetailEventChangeStatus(status: EnumStatusState.loading));
    final project = event.data!;

    await Future.wait([
      repo.initTaskRealtime(projectId: project.dataProject.id),
      repo.initTaskLabelRealtime(projectId: project.dataProject.id),
      repo.initSubTaskRealtime(projectId: project.dataProject.id),
      repo.initLabelRealtime(),
    ]);

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

  FutureOr<void> _onSelectedData(
    ProjectDetailEventSelectedData event,
    Emitter<ProjectDetailState> emit,
  ) {
    emit(
      (state as ProjectDetailStateLoaded).copyWith(
        selectedTask: event.selectedDate,
      ),
    );
  }

  FutureOr<void> _onResetSelected(
    ProjectDetailEventResetSelected event,
    Emitter<ProjectDetailState> emit,
  ) {
    emit((state as ProjectDetailStateLoaded).copyWith(selectedTask: null));
  }

  Future<void> _onDeleteTask(
    ProjectDetailEventDeleteTask event,
    Emitter<ProjectDetailState> emit,
  ) async {
    add(ProjectDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final data = await repo.deleteTask(taskId: event.taskId);
    if (data != null) {
      emit(
        (state as ProjectDetailStateLoaded).copyWith(
          error: data.error,
          failed: data.failed,
          noconnection: data.noconnection,
          status: EnumStatusState.none,
        ),
      );
    }
  }

  Future<void> _onUpdateTask(
    ProjectDetailEventUpdateTask event,
    Emitter<ProjectDetailState> emit,
  ) async {
    add(ProjectDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as ProjectDetailStateLoaded;
    final original = currentState.selectedTask!;
    final edited = original.copyWith(
      dataTask: original.dataTask.copyWith(
        description: event.description,
        startDate: event.start,
        dueDate: event.due,
        storyPoint: event.storyPoint,
        status: event.status,
        priority: event.priority,
      ),
    );

    final data = await repo.updateTask(original: original, edited: edited);

    if (data != null) {
      emit(
        (state as ProjectDetailStateLoaded).copyWith(
          error: data.error,
          failed: data.failed,
          noconnection: data.noconnection,
          status: EnumStatusState.none,
        ),
      );
    }
  }

  Future<void> _onCreateTask(
    ProjectDetailEventCreateTask event,
    Emitter<ProjectDetailState> emit,
  ) async {
    add(ProjectDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as ProjectDetailStateLoaded;
    final data = await repo.createTask(
      assigneeId: event.assigneeId,
      title: event.title,
      projectId: currentState.dataProject!.dataProject.id,
      description: event.description,
      startDate: event.start,
      dueDate: event.due,
      storyPoint: event.storyPoint,
      status: event.status,
      priority: event.priority,
    );
    if (data != null) {
      emit(
        currentState.copyWith(
          error: data.error,
          failed: data.failed,
          noconnection: data.noconnection,
          status: EnumStatusState.none,
        ),
      );
    }
  }
}
