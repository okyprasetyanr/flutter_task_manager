import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/task_detail/domain/repository/task_detail_repository.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_comment.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final TaskDetailRepository repo;

  TaskDetailBloc(this.repo) : super(TaskDetailStateInitial()) {
    on<TaskDetailEventGetData>(_onGetData);
    on<TaskDetailEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onGetData(
    TaskDetailEventGetData event,
    Emitter<TaskDetailState> emit,
  ) async {
    final currentState = state is TaskDetailStateLoaded
        ? state as TaskDetailStateLoaded
        : TaskDetailStateLoaded();
    add(TaskDetailEventChangeStatus(status: EnumStatusState.loading));
    final dataTask = event.dataTask ?? currentState.dataTask!;
    final dataSubTask = dataTask.subTask;
    final dataLabel = dataTask.label;
    final data = await repo.getComment(taskId: dataTask.id);
    final dataUser = repo.getUser();
    emit(
      currentState.copyWith(
        dataLabel: dataLabel,
        dataComment: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelComment.fromJson(e))
                  .toSet()
            : const {},
        dataUser: dataUser,
        dataSubTask: dataSubTask,
        dataTask: dataTask,
        status: EnumStatusState.none,
        error: data.$2.error,
        failed: data.$2.failed,
        noconnection: data.$2.noconnection,
      ),
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
}
