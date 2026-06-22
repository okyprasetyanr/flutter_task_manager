import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/activity/domain/repository/activity_repository.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_event.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository repo;
  ActivityBloc(this.repo) : super(ActivityStateInitial()) {
    on<ActivityEventWatchActivity>(_onWatchDashboard);
    on<ActivityEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onWatchDashboard(
    ActivityEventWatchActivity event,
    Emitter<ActivityState> emit,
  ) async {
    add(ActivityEventChangeStatus(status: EnumStatusState.loading));
    final workspace = event.data!;
    await repo.initActivityRealTime(workspaceId: workspace.dataWorkspace.id);
    await emit.forEach(
      repo.watchDashboard(workspace: workspace),
      onData: (data) {
        return data;
      },
      onError: (error, stackTrace) =>
          (state is ActivityStateLoaded
                  ? state as ActivityStateLoaded
                  : ActivityStateLoaded())
              .copyWith(
                error: error.toString(),
                workspace: workspace,
                status: EnumStatusState.none,
              ),
    );
  }

  FutureOr<void> _onChangeStatus(
    ActivityEventChangeStatus event,
    Emitter<ActivityState> emit,
  ) {
    emit(
      (state is ActivityStateLoaded
              ? state as ActivityStateLoaded
              : ActivityStateLoaded())
          .copyWith(status: event.status),
    );
  }

  @override
  Future<void> close() {
    repo.disposeActivityRealtime();
    return super.close();
  }
}
