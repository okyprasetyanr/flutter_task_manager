import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_member.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final WorkspaceRepository repo;
  WorkspaceBloc(this.repo) : super(WorkspaceStateInitial()) {
    on<WorkspaceEventWatch>(_onWatch);
    on<WorkspaceEventWatchMessage>(_onWatchMessage);
    on<WorkspaceEventWatchMember>(_onWatchMember);
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

  Future<void> _onWatch(
    WorkspaceEventWatch event,
    Emitter<WorkspaceState> emit,
  ) async {
    add(WorkspaceEventChangeStatus(status: EnumStatusState.loading));
    final currentState = state is WorkspaceStateLoaded
        ? state as WorkspaceStateLoaded
        : WorkspaceStateLoaded();
    final company = repo.getCompanyName();
    await emit.forEach<Map<String, dynamic>>(
      repo.watchWorkspace(),
      onData: (data) {
        devLog("Log WorkspaceBloc: data:$data");
        return currentState.copyWith(
          companyName: company,
          dataWorkspace: (data[EnumFetchApiValue.results.name] as List)
              .map(
                (e) => ModelWorkspaceMerge(
                  dataWorkspace: ModelWorkspace.fromDrift(e),
                  dataWorkspaceMember:
                      currentState.selectedWorkspace?.dataWorkspaceMember ??
                      const {},
                ),
              )
              .toSet(),
          dataUser: repo.getUser(),
          initMember: currentState.initMember ?? true,
        );
      },
      onError: (error, stackTrace) {
        devLog("Log WorkspaceBloc: onError: ${error.toString()}");
        return currentState.copyWith(error: error.toString());
      },
    );
  }

  Future<void> _onWatchMessage(
    WorkspaceEventWatchMessage event,
    Emitter<WorkspaceState> emit,
  ) async {
    final currentState = state is WorkspaceStateLoaded
        ? state as WorkspaceStateLoaded
        : WorkspaceStateLoaded();
    await emit.forEach<CollectorMessage>(
      repo.watchWorkspaceMessage(),
      onData: (data) {
        return currentState.copyWith(
          status: EnumStatusState.none,
          error: data.error,
          failed: data.failed,
          noconnection: data.noconnection,
        );
      },
      onError: (error, stackTrace) {
        devLog("Log WorkspaceBloc: onErrorMessage: ${error.toString()}");
        return currentState.copyWith(
          status: EnumStatusState.none,
          error: error.toString(),
        );
      },
    );
  }

  Future<void> _onWatchMember(
    WorkspaceEventWatchMember event,
    Emitter<WorkspaceState> emit,
  ) async {
    add(WorkspaceEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as WorkspaceStateLoaded;
    await emit.forEach(
      repo.watchWorkspaceMember(),
      onData: (data) {
        List<ModelWorkspaceMember> finalData =
            data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelWorkspaceMember.fromJson(e))
                  .toList()
            : const [];
        devLog("Log WorkspaceBloc: watchMember: data: $finalData");
        return currentState.copyWith(
          dataWorkspace: currentState.dataWorkspace.map((workspace) {
            return workspace.copyWith(
              dataWorkspaceMember: currentState.dataUser.where((user) {
                return finalData.any(
                  (workspaceMember) =>
                      workspaceMember.workspaceId ==
                          workspace.dataWorkspace.id &&
                      workspaceMember.userId == user.id,
                );
              }).toSet(),
            );
          }).toSet(),
          initMember: false,
          status: EnumStatusState.none,
          error: data.$2.error,
          failed: data.$2.failed,
          noconnection: data.$2.noconnection,
        );
      },
      onError: (error, stackTrace) => currentState.copyWith(
        status: EnumStatusState.none,
        error: error.toString(),
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
    final edited = original.dataWorkspace.copyWith(
      name: event.name,
      description: event.description,
    );
    if (original != edited) {
      add(WorkspaceEventChangeStatus(status: EnumStatusState.synchronize));
      final data = await repo.updateWorkspace(
        original: currentState.selectedWorkspace!.dataWorkspace,
        edited: edited,
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
}
