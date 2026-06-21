import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_member.dart';

class WorkspaceDetailBloc
    extends Bloc<WorkspaceDetailEvent, WorkspaceDetailState> {
  final WorkspaceDetailRepository repo;

  WorkspaceDetailBloc(this.repo) : super(WorkspaceDetailStateInitial()) {
    on<WorkspaceDetailEventWatch>(_onWatch);
    on<WorkspaceDetailEventWatchMember>(_onWatchMember);
    on<WorkspaceDetailEventChangeStatus>(_onChangeStatus);
    on<WorkspaceDetailEventCreateProject>(_onCreateProject);
    on<WorkspaceDetailEventUpdateProject>(_onUpdateProject);
    on<WorkspaceDetailEventDeleteProject>(_onDeleteProject);
    on<WorkspaceDetailEventSelectedProject>(_onSelectedProject);
    on<WorkspaceDetailEventResetSelected>(_onResetSelected);
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
    await repo.initProjectRealtime(workspaceId: event.data!.dataWorkspace.id);
    final currentState = state is WorkspaceDetailStateLoaded
        ? state as WorkspaceDetailStateLoaded
        : WorkspaceDetailStateLoaded();
    final workspace = event.data!;
    await emit.forEach(
      repo.watchProject(workspaceId: workspace.dataWorkspace.id),
      onData: (data) {
        return currentState.copyWith(
          workspace: workspace,
          dataProject: data.$1.containsKey(EnumFetchApiStatus.success)
              ? (data.$1[EnumFetchApiStatus.success] as List).map((e) {
                  devLog(
                    "Log WorkspaceDetailBloc: onWatch: data: ${ModelProject.fromDrift(e)}",
                  );
                  return ModelProjectMerge(
                    dataProject: ModelProject.fromDrift(e),
                    dataProjectMember:
                        currentState.selectedProject?.dataProjectMember ??
                        const {},
                  );
                }).toSet()
              : const {},
          selectedProject: currentState.selectedProject,
          initMember: currentState.initMember ?? true,
          dataUser: workspace.dataWorkspaceMember,
          error: data.$2.error,
          failed: data.$2.failed,
          noconnection: data.$2.noconnection,
          status: EnumStatusState.none,
        );
      },
      onError: (error, stackTrace) => currentState.copyWith(
        status: EnumStatusState.none,
        error: error.toString(),
      ),
    );
  }

  Future<void> _onWatchMember(
    WorkspaceDetailEventWatchMember event,
    Emitter<WorkspaceDetailState> emit,
  ) async {
    add(WorkspaceDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state is WorkspaceDetailStateLoaded
        ? state as WorkspaceDetailStateLoaded
        : WorkspaceDetailStateLoaded();
    await repo.initMemberRealtime(
      workspaceId: currentState.workspace!.dataWorkspace.id,
    );
    await emit.forEach(
      repo.watchMember(workspaceId: currentState.workspace!.dataWorkspace.id),
      onData: (data) {
        final current = state is WorkspaceDetailStateLoaded
            ? state as WorkspaceDetailStateLoaded
            : WorkspaceDetailStateLoaded();
        Set<ModelProjectMember> finalData =
            data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelProjectMember.fromDrift(e))
                  .toSet()
            : const {};
        devLog(
          "Log WorkspaceDetailBloc: watchMember: data: ${data.toString()}",
        );
        return current.copyWith(
          dataProject: current.dataProject.map((project) {
            return project.copyWith(
              dataProjectMember: current.dataUser.where((user) {
                return finalData.any(
                  (projectMember) =>
                      projectMember.projectId == project.dataProject.id &&
                      projectMember.userId == user.id,
                );
              }).toSet(),
            );
          }).toSet(),
          selectedProject: currentState.selectedProject,
          status: EnumStatusState.none,
          error: data.$2.error,
          failed: data.$2.failed,
          noconnection: data.$2.noconnection,
        );
      },
      onError: (error, stackTrace) {
        final current = state is WorkspaceDetailStateLoaded
            ? state as WorkspaceDetailStateLoaded
            : WorkspaceDetailStateLoaded();
        return current.copyWith(
          status: EnumStatusState.none,
          error: error.toString(),
        );
      },
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
      dataProjectMember: event.contributor.isEmpty
          ? currentState.selectedProject!.dataProjectMember
          : event.contributor.map((e) => e.$1).toSet(),
    );
    if (original != edited) {
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
    repo.disposeWorkspaceRealtime();
    devLog("Log WorkspaceDetail: cancel: checked");
    return super.close();
  }
}
