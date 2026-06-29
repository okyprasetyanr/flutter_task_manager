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
    on<TaskDetailEventDeleteComment>(_onDeleteComment);
    on<TaskDetailEventDeleteSubtask>(_onDeleteSubtask);
    on<TaskDetailEventCreateComment>(_onCreateComment);
    on<TaskDetailEventCreateSubtask>(_onCreateSubtask);
    on<TaskDetailEventUpdateSubtask>(_onUpdateSubtask);
    on<TaskDetailEventSelectedSubtask>(_onSelectedSubtask);
    on<TaskDetailEventResetSelected>(_onResetSelectedSubTask);
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
    final currentState = state is TaskDetailStateLoaded
        ? state as TaskDetailStateLoaded
        : TaskDetailStateLoaded();
    emit(
      currentState.copyWith(
        status: event.status,
        selectedSubtask: currentState.selectedSubtask,
      ),
    );
  }

  @override
  Future<void> close() {
    repo.disposeRealtime();
    return super.close();
  }

  Future<void> _onCreateSubtask(
    TaskDetailEventCreateSubtask event,
    Emitter<TaskDetailState> emit,
  ) async {
    add(TaskDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as TaskDetailStateLoaded;
    final data = await repo.createSubTask(
      title: event.title,
      taskId: currentState.task!.dataTask.id,
      projectId: currentState.task!.dataTask.projectId,
    );

    emit(
      currentState.copyWith(
        error: data?.error,
        failed: data?.failed,
        noconnection: data?.noconnection,
        status: EnumStatusState.none,
      ),
    );
  }

  Future<void> _onCreateComment(
    TaskDetailEventCreateComment event,
    Emitter<TaskDetailState> emit,
  ) async {
    add(TaskDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as TaskDetailStateLoaded;
    final data = await repo.createComment(
      content: event.content,
      taskId: currentState.task!.dataTask.id,
    );

    emit(
      currentState.copyWith(
        error: data?.error,
        failed: data?.failed,
        noconnection: data?.noconnection,
        status: EnumStatusState.none,
      ),
    );
  }

  Future<void> _onDeleteSubtask(
    TaskDetailEventDeleteSubtask event,
    Emitter<TaskDetailState> emit,
  ) async {
    add(TaskDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as TaskDetailStateLoaded;
    final data = await repo.deleteSubTask(
      subtaskId: currentState.selectedSubtask!.id,
    );

    emit(
      currentState.copyWith(
        error: data?.error,
        failed: data?.failed,
        noconnection: data?.noconnection,
        status: EnumStatusState.none,
      ),
    );
  }

  Future<void> _onDeleteComment(
    TaskDetailEventDeleteComment event,
    Emitter<TaskDetailState> emit,
  ) async {
    add(TaskDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as TaskDetailStateLoaded;
    final data = await repo.deleteComment(commentId: event.commentId);

    emit(
      currentState.copyWith(
        error: data?.error,
        failed: data?.failed,
        noconnection: data?.noconnection,
        status: EnumStatusState.none,
      ),
    );
  }

  FutureOr<void> _onSelectedSubtask(
    TaskDetailEventSelectedSubtask event,
    Emitter<TaskDetailState> emit,
  ) {
    emit(
      (state as TaskDetailStateLoaded).copyWith(selectedSubtask: event.data),
    );
  }

  Future<void> _onUpdateSubtask(
    TaskDetailEventUpdateSubtask event,
    Emitter<TaskDetailState> emit,
  ) async {
    add(TaskDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as TaskDetailStateLoaded;
    final original = currentState.selectedSubtask!;
    final edited = original.copyWith(title: event.title, isDone: event.isDone);
    final data = await repo.updateSubtask(original: original, edited: edited);

    emit(
      currentState.copyWith(
        error: data?.error,
        failed: data?.failed,
        noconnection: data?.noconnection,
        status: EnumStatusState.none,
      ),
    );
  }

  FutureOr<void> _onResetSelectedSubTask(
    TaskDetailEventResetSelected event,
    Emitter<TaskDetailState> emit,
  ) {
    emit((state as TaskDetailStateLoaded).copyWith(selectedSubtask: null));
  }
}
