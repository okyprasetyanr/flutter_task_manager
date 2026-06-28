import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceDetailBloc
    extends Bloc<WorkspaceDetailEvent, WorkspaceDetailState> {
  final WorkspaceDetailRepository repo;

  WorkspaceDetailBloc(this.repo) : super(WorkspaceDetailStateInitial()) {
    on<WorkspaceDetailEventWatch>(_onWatch);
    on<WorkspaceDetailEventChangeStatus>(_onChangeStatus);
    on<WorkspaceDetailEventCreateProject>(_onCreateProject);
    on<WorkspaceDetailEventUpdateProject>(_onUpdateProject);
    on<WorkspaceDetailEventDeleteProject>(_onDeleteProject);
    on<WorkspaceDetailEventSelectedProject>(_onSelectedProject);
    on<WorkspaceDetailEventResetSelected>(_onResetSelected);
    on<WorkspaceDetailEventSearchMember>(_onSearchMember);
  }

  FutureOr<void> _onChangeStatus(
    WorkspaceDetailEventChangeStatus event,
    Emitter<WorkspaceDetailState> emit,
  ) {
    final currentState = state is WorkspaceDetailStateLoaded
        ? state as WorkspaceDetailStateLoaded
        : WorkspaceDetailStateLoaded();
    emit(
      currentState.copyWith(
        status: event.status,
        selectedProject: currentState.selectedProject,
      ),
    );
  }

  Future<void> _onWatch(
    WorkspaceDetailEventWatch event,
    Emitter<WorkspaceDetailState> emit,
  ) async {
    add(WorkspaceDetailEventChangeStatus(status: EnumStatusState.loading));
    final workspace = event.data!;
    await repo.initProjectRealtime(workspaceId: event.data!.dataWorkspace.id);
    await repo.initMemberRealtime(workspaceId: event.data!.dataWorkspace.id);
    await emit.forEach(
      repo.watchDashboard(workspace: workspace),
      onData: (data) {
        return data;
      },
      onError: (error, stackTrace) =>
          (state is WorkspaceDetailStateLoaded
                  ? state as WorkspaceDetailStateLoaded
                  : WorkspaceDetailStateLoaded())
              .copyWith(
                workspaceName: event.data!.dataWorkspace.name,
                status: EnumStatusState.none,
                error: error.toString(),
              ),
    );
  }

  FutureOr<void> _onSelectedProject(
    WorkspaceDetailEventSelectedProject event,
    Emitter<WorkspaceDetailState> emit,
  ) {
    emit(
      (state as WorkspaceDetailStateLoaded).copyWith(
        selectedProject: event.data,
      ),
    );
  }

  Future<void> _onCreateProject(
    WorkspaceDetailEventCreateProject event,
    Emitter<WorkspaceDetailState> emit,
  ) async {
    add(WorkspaceDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as WorkspaceDetailStateLoaded;
    final data = await repo.createProject(
      name: event.name,
      start: event.start,
      end: event.end,
      contributor: event.contributor.map((e) {
        return (e.$1.id, e.$2);
      }).toSet(),
      type: event.type,
      workspaceId: currentState.workspace!.dataWorkspace.id,
    );

    if (data != null) {
      emit(currentState.copyWith(error: data.error, failed: data.failed));
    }
  }

  Future<void> _onUpdateProject(
    WorkspaceDetailEventUpdateProject event,
    Emitter<WorkspaceDetailState> emit,
  ) async {
    add(WorkspaceDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as WorkspaceDetailStateLoaded;
    final original = currentState.selectedProject!;
    final edited = original.copyWith(
      dataProject: original.dataProject.copyWith(
        end: event.end,
        start: event.start,
        type: event.type,
        totalContribut: event.contributor.length,
        status: event.status,
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
      final data = await repo.updateProject(
        original: currentState.selectedProject!,
        edited: edited,
        contributor: event.contributor.map((e) {
          return (e.$1.id, e.$2);
        }).toSet(),
      );

      if (data != null) {
        emit(currentState.copyWith(error: data.error, failed: data.failed));
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

  Future<void> _onDeleteProject(
    WorkspaceDetailEventDeleteProject event,
    Emitter<WorkspaceDetailState> emit,
  ) async {
    add(WorkspaceDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state as WorkspaceDetailStateLoaded;
    final data = await repo.deleteProject(
      currentState.selectedProject!.dataProject.id,
    );
    if (data != null) {
      emit(currentState.copyWith(error: data.error, failed: data.failed));
    }
  }

  FutureOr<void> _onResetSelected(
    WorkspaceDetailEventResetSelected event,
    Emitter<WorkspaceDetailState> emit,
  ) {
    emit((state as WorkspaceDetailStateLoaded).copyWith(selectedProject: null));
  }

  @override
  Future<void> close() {
    repo.disposeRealtime();
    devLog("Log WorkspaceDetail: cancel: checked");
    return super.close();
  }

  FutureOr<void> _onSearchMember(
    WorkspaceDetailEventSearchMember event,
    Emitter<WorkspaceDetailState> emit,
  ) {
    final currentState = state as WorkspaceDetailStateLoaded;
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
