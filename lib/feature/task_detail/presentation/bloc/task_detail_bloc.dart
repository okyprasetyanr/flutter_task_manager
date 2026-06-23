import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/task_detail/domain/repository/task_detail_repository.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final TaskDetailRepository repo;

  TaskDetailBloc(this.repo) : super(TaskDetailStateInitial()) {
    on<TaskDetailEventWatchDashboard>(_onWatchDashboard);
    on<TaskDetailEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onWatchDashboard(
    TaskDetailEventWatchDashboard event,
    Emitter<TaskDetailState> emit,
  ) async {
    add(TaskDetailEventChangeStatus(status: EnumStatusState.loading));
    final task = event.dataTask!;
    final label = event.dataLabel!;
    await repo.initCommentRealtime(taskId: task.dataTask.id);
    await emit.forEach<TaskDetailStateLoaded>(
      repo.watchDashboard(task: task, label: label),
      onData: (data) {
        return data;
      },
      onError: (error, stackTrace) {
        return TaskDetailStateLoaded(
          error: error.toString(),
          status: EnumStatusState.none,
          task: task,
        );
      },
    );
  }

  FutureOr<void> _onChangeStatus(
    TaskDetailEventChangeStatus event,
    Emitter<TaskDetailState> emit,
  ) {
    emit(
      (state is TaskDetailStateLoaded
              ? state as TaskDetailStateLoaded
              : TaskDetailStateLoaded())
          .copyWith(status: event.status),
    );
  }

  @override
  Future<void> close() {
    repo.disposeRealtime();
    return super.close();
  }
}
