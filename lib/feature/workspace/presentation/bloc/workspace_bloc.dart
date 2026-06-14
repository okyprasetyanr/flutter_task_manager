import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final WorkspaceRepository repo;
  WorkspaceBloc(this.repo) : super(WorkspaceStateInitial()) {
    on<WorkspaceEventWatchWorkspace>(_watchWorkspace);
    on<WorkspaceEventChangeStatus>(_onChangeStatus);
    on<WorkspaceEventCreateWorkspace>(_onCreateWorkspace);
    on<WorkspaceEventSelectedData>(_onSelectedData);
    on<WorkspaceEventUpdateWorkspace>(_onUpdate);
    on<WorkspaceEventDeleteWorkspace>(_onDelete);
  }

  FutureOr<void> _onChangeStatus(
    WorkspaceEventChangeStatus event,
    Emitter<WorkspaceState> emit,
  ) {
    final currentState = state is WorkspaceStateLoaded
        ? state as WorkspaceStateLoaded
        : WorkspaceStateLoaded();
    emit(
      currentState.copyWith(
        status: event.status,
        selectedWorkspace: currentState.selectedWorkspace,
      ),
    );
  }

  Future<void> _watchWorkspace(
    WorkspaceEventWatchWorkspace event,
    Emitter<WorkspaceState> emit,
  ) async {
    final currentState = state is WorkspaceStateLoaded
        ? state as WorkspaceStateLoaded
        : WorkspaceStateLoaded();
    final company = repo.getCompanyName();
    await emit.forEach<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>(
      repo.watchWorkspace(),
      onData: (data) {
        final List<dynamic> listData =
            data.$1[EnumFetchApiStatus.success] as List? ?? [];

        return currentState.copyWith(
          companyName: company,
          status: EnumStatusState.none,
          dataWorkspace: data.$1.containsKey(EnumFetchApiStatus.success)
              ? listData.map((e) => ModelWorkspace.fromJson(e)).toList()
              : const [],
          failed: data.$2.failed,
          noconnection: data.$2.noconnection,
        );
      },
      onError: (error, stackTrace) {
        final currentState = state is WorkspaceStateLoaded
            ? state as WorkspaceStateLoaded
            : WorkspaceStateLoaded();

        return currentState.copyWith(
          status: EnumStatusState.none,
          error: error.toString(),
        );
      },
    );
  }

  FutureOr<void> _onSelectedData(
    WorkspaceEventSelectedData event,
    Emitter<WorkspaceState> emit,
  ) {
    emit(
      (state as WorkspaceStateLoaded).copyWith(selectedWorkspace: event.data),
    );
  }

  Future<void> _onCreateWorkspace(
    WorkspaceEventCreateWorkspace event,
    Emitter<WorkspaceState> emit,
  ) async {
    add(WorkspaceEventChangeStatus(status: EnumStatusState.loading));
    final data = await repo.createWorkspace(data: event.data);
    if (data != null) {
      emit(
        (state as WorkspaceStateLoaded).copyWith(
          error: data.error,
          failed: data.error,
          status: EnumStatusState.none,
        ),
      );
    }
  }

  Future<void> _onUpdate(
    WorkspaceEventUpdateWorkspace event,
    Emitter<WorkspaceState> emit,
  ) async {
    final currentState = state as WorkspaceStateLoaded;
    if (currentState.selectedWorkspace != event.data) {
      add(WorkspaceEventChangeStatus(status: EnumStatusState.loading));
      final data = await repo.updateWorkspace(
        original: currentState.selectedWorkspace!,
        edited: event.data,
      );
      if (data != null) {
        emit(
          currentState.copyWith(
            error: data.error,
            failed: data.error,
            status: EnumStatusState.none,
          ),
        );
      }
    } else {
      emit(
        currentState.copyWith(
          status: EnumStatusState.none,
          error: "Nothing changed!",
        ),
      );
    }
  }

  FutureOr<void> _onDelete(
    WorkspaceEventDeleteWorkspace event,
    Emitter<WorkspaceState> emit,
  ) async {
    add(WorkspaceEventChangeStatus(status: EnumStatusState.loading));
    final data = await repo.deleteWorkspace(workspaceId: event.idWorkspace);
    if (data != null) {
      emit(
        (state as WorkspaceStateLoaded).copyWith(
          error: data.error,
          failed: data.error,
          status: EnumStatusState.none,
        ),
      );
    }
  }
}
