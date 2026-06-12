import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final WorkspaceRepository repo;
  WorkspaceBloc(this.repo) : super(WorkspaceStateInitial()) {
    on<WorkspaceEventGetData>(_onGetData);
    on<WorkspaceEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onGetData(
    WorkspaceEventGetData event,
    Emitter<WorkspaceState> emit,
  ) async {
    final currentState = state is WorkspaceStateLoaded
        ? state as WorkspaceStateLoaded
        : WorkspaceStateLoaded();
    add(WorkspaceEventChangeStatus(status: EnumStatusState.loading));
    final data = await repo.getWorkspace();
    final company = repo.getCompanyName();

    emit(
      currentState.copyWith(
        companyName: company,
        status: EnumStatusState.none,
        dataWorkspace: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelWorkspace.fromJson(e))
                  .toList()
            : const [],
        failed: data.$2.failed,
        error: data.$2.error,
        noconnection: data.$2.noconnection,
      ),
    );
  }

  FutureOr<void> _onChangeStatus(
    WorkspaceEventChangeStatus event,
    Emitter<WorkspaceState> emit,
  ) {
    emit(
      (state is WorkspaceStateLoaded
              ? state as WorkspaceStateLoaded
              : WorkspaceStateLoaded())
          .copyWith(status: event.status),
    );
  }
}
