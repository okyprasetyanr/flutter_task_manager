import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/debounce/debounce_event_bloc.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

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
    on<WorkspaceEventSearchMember>(
      _onSearchMember,
      transformer: debounceRestartable(),
    );
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
    );
    final editedContributors = event.contributor
        .map((e) => (e.$1.id, e.$2))
        .toSet();

    if (original != edited ||
        original.dataMember.any(
          (element) =>
              !editedContributors.contains((element.userId, element.role)),
        )) {
      add(WorkspaceEventChangeStatus(status: EnumStatusState.synchronize));
      devLog("Log WorkspaceBloc: update: ${event.contributor}");
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
          selectedWorkspace: currentState.selectedWorkspace!,
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

  FutureOr<void> _onSearchMember(
    WorkspaceEventSearchMember event,
    Emitter<WorkspaceState> emit,
  ) {
    final currentState = state as WorkspaceStateLoaded;
    final data = currentState.dataUser
        .where((element) => element.name.contains(event.search))
        .toSet();
    emit(
      currentState.copyWith(
        filteredUser: event.search.isEmpty ? currentState.dataUser : data,
      ),
    );
  }
}
