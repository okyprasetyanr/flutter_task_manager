import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final WorkspaceRepository repo;
  WorkspaceBloc(this.repo) : super(WorkspaceStateInitial()) {
    on<WorkspaceEventWatch>(_onWatch);
    on<WorkspaceEventChangeStatus>(_onChangeStatus);
    on<WorkspaceEventCreateWorkspace>(_onCreateWorkspace);
    on<WorkspaceEventSelectedData>(_onSelectedData);
    on<WorkspaceEventUpdateWorkspace>(_onUpdate);
    on<WorkspaceEventDeleteWorkspace>(_onDelete);
    on<WorkspaceEventResetSelected>(_onResetSelected);
  }

  Future<void> _onWatch(
    WorkspaceEventWatch event,
    Emitter<WorkspaceState> emit,
  ) async {
    add(WorkspaceEventChangeStatus(status: EnumStatusState.loading));
    await repo.initWorkspaceRealtime();
    await repo.initMemberRealtime();
    await emit.forEach<WorkspaceStateLoaded>(
      repo.watchDashboard(),
      onData: (data) {
        return data;
      },
      onError: (error, stackTrace) {
        return WorkspaceStateLoaded(
          companyName: repo.getCompanyName(),
          status: EnumStatusState.none,
          error: error.toString(),
        );
      },
    );
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
    add(WorkspaceEventChangeStatus(status: EnumStatusState.synchronize));
    final data = await repo.createWorkspace(
      description: event.description,
      name: event.name,
      contributor: event.contributor.map((e) => (e.$1.id, e.$2)).toSet(),
    );
    if (data != null) {
      emit(
        (state as WorkspaceStateLoaded).copyWith(
          error: data.error,
          failed: data.failed,
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
    final original = currentState.selectedWorkspace!;
    final edited = original.copyWith(
      dataWorkspace: original.dataWorkspace.copyWith(
        name: event.name,
        description: event.description,
      ),
      dataWorkspaceMember: event.contributor.isEmpty
          ? original.dataWorkspaceMember
          : event.contributor.map((e) => e.$1).toSet(),
    );
    if (original != edited) {
      add(WorkspaceEventChangeStatus(status: EnumStatusState.synchronize));
      final data = await repo.updateWorkspace(
        original: currentState.selectedWorkspace!,
        edited: edited,
        contributor: event.contributor.map((e) => (e.$1.id, e.$2)).toSet(),
      );
      if (data != null) {
        emit(
          currentState.copyWith(
            error: data.error,
            failed: data.failed,
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
    add(WorkspaceEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as WorkspaceStateLoaded;
    final data = await repo.deleteWorkspace(
      workspaceId: currentState.selectedWorkspace!.dataWorkspace.id,
    );
    if (data != null) {
      emit(
        currentState.copyWith(
          error: data.error,
          failed: data.failed,
          status: EnumStatusState.none,
        ),
      );
    }
  }

  FutureOr<void> _onResetSelected(
    WorkspaceEventResetSelected event,
    Emitter<WorkspaceState> emit,
  ) {
    emit((state as WorkspaceStateLoaded).copyWith(selectedWorkspace: null));
  }

  @override
  Future<void> close() {
    repo.disposeRealtime();
    return super.close();
  }
}
