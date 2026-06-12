import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/activity/domain/repository/activity_repository.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_event.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_activity.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository repo;
  ActivityBloc(this.repo) : super(ActivityStateInitial()) {
    on<ActivityEventGetData>(_onGetData);
    on<ActivityEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onGetData(
    ActivityEventGetData event,
    Emitter<ActivityState> emit,
  ) async {
    add(ActivityEventChangeStatus(status: EnumStatusState.loading));
    final currentState = state is ActivityStateLoaded
        ? state as ActivityStateLoaded
        : ActivityStateLoaded();
    final dataWorkspace = event.data ?? currentState.dataWorkspace!;
    final data = await repo.getActivity(workspaceId: dataWorkspace.workspaceId);
    emit(
      currentState.copyWith(
        dataActivity: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelActivity.fromJson(e))
                  .toList()
            : const [],
        dataUser: repo.getUser(),
        dataWorkspace: dataWorkspace,
        error: data.$2.error,
        failed: data.$2.failed,
        noconnection: data.$2.noconnection,
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
}
