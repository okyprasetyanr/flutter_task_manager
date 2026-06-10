import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/history_task/domain/repository/history_task_repository.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_event.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_task_history.dart';

class HistoryTaskBloc extends Bloc<HistoryTaskEvent, HistoryTaskState> {
  final HistoryTaskRepository repo;
  HistoryTaskBloc(this.repo) : super(HistoryTaskStateInitial()) {
    on<HistoryTaskEventGetData>(_onGetData);
    on<HistoryTaskEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onGetData(
    HistoryTaskEventGetData event,
    Emitter<HistoryTaskState> emit,
  ) async {
    final currentState = state is HistoryTaskStateLoaded
        ? state as HistoryTaskStateLoaded
        : HistoryTaskStateLoaded();
    add(HistoryTaskEventChangeStatus(status: EnumStatusState.loading));
    final data = await repo.getHistoryTask();
    final dataWorkspace = event.data ?? currentState.dataWorkspace!;
    final dataUser = event.user ?? currentState.dataUser;
    emit(
      currentState.copyWith(
        dataUser: dataUser,
        dataHistoryTask: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelHistoryTask.fromJson(e))
                  .toList()
            : [],
        dataWorkspace: dataWorkspace,
        error: data.$2.error,
        failed: data.$2.failed,
        noconnection: data.$2.noconnection,
        status: EnumStatusState.none,
      ),
    );
  }

  FutureOr<void> _onChangeStatus(
    HistoryTaskEventChangeStatus event,
    Emitter<HistoryTaskState> emit,
  ) {
    emit(
      (state is HistoryTaskStateLoaded
              ? state as HistoryTaskStateLoaded
              : HistoryTaskStateLoaded())
          .copyWith(status: event.status),
    );
  }

  void data() {}
}
