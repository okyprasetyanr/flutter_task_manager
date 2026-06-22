import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/history_task/domain/repository/history_task_repository.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_event.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class HistoryTaskBloc extends Bloc<HistoryTaskEvent, HistoryTaskState> {
  final HistoryTaskRepository repo;
  HistoryTaskBloc(this.repo) : super(HistoryTaskStateInitial()) {
    on<HistoryTaskEventWatchHistory>(_onWatchDashboard);
    on<HistoryTaskEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onWatchDashboard(
    HistoryTaskEventWatchHistory event,
    Emitter<HistoryTaskState> emit,
  ) async {
    add(HistoryTaskEventChangeStatus(status: EnumStatusState.loading));
    final workspace = event.data!;
    await repo.initHistoryRealTime(workspaceId: workspace.dataWorkspace.id);
    await emit.forEach<HistoryTaskStateLoaded>(
      repo.watchDashboard(workspace: workspace),
      onData: (data) {
        devLog("Log HistoryTaskBloc: watchDashboard: checked");
        return data;
      },
      onError: (error, stackTrace) =>
          (state is HistoryTaskStateLoaded
                  ? state as HistoryTaskStateLoaded
                  : HistoryTaskStateLoaded())
              .copyWith(
                error: error.toString(),
                workspace: workspace,
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

  @override
  Future<void> close() {
    repo.disposeHistoryRealtime();
    return super.close();
  }
}
