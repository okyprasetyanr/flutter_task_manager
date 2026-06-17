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
    on<WorkspaceDEtailEventSelectedProject>(_onSelectedProject);
  }

  FutureOr<void> _onChangeStatus(
    WorkspaceDetailEventChangeStatus event,
    Emitter<WorkspaceDetailState> emit,
  ) {
    emit(
      (state is WorkspaceDetailStateLoaded
              ? state as WorkspaceDetailStateLoaded
              : WorkspaceDetailStateLoaded())
          .copyWith(status: event.status),
    );
  }

  Future<void> _onWatch(
    WorkspaceDetailEventWatch event,
    Emitter<WorkspaceDetailState> emit,
  ) async {
    add(WorkspaceDetailEventChangeStatus(status: EnumStatusState.loading));
    final currentState = state is WorkspaceDetailStateLoaded
        ? state as WorkspaceDetailStateLoaded
        : WorkspaceDetailStateLoaded();
    final dataWorkspace = event.data!;
    await emit.forEach(
      repo.watchProject(workspaceId: dataWorkspace.dataWorkspace.id),
      onData: (data) {
        return currentState.copyWith(
          dataWorkspace: dataWorkspace,
          dataUser: repo.getUser(),
          dataProject: data.$1.containsKey(EnumFetchApiStatus.success)
              ? (data.$1[EnumFetchApiStatus.success] as List)
                    .map(
                      (e) => ModelProjectMerge(
                        dataProject: ModelProject.fromJson(e),
                        dataProjectMember:
                            currentState.selectedProject?.dataProjectMember ??
                            const {},
                      ),
                    )
                    .toSet()
              : const {},
          initMember: true,
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
    final currentState = state as WorkspaceDetailStateLoaded;
    devLog(
      "Log WorkspaceDetailBloc: watchMember: listId: ${(state as WorkspaceDetailStateLoaded).dataProject.map((e) => e.dataProject.id).toList()}",
    );
    await emit.forEach(
      repo.watchProjectMember(
        workspaceId: (state as WorkspaceDetailStateLoaded)
            .dataWorkspace!
            .dataWorkspace
            .id,
      ),
      onData: (data) {
        Set<ModelProjectMember> finalData =
            data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelProjectMember.fromJson(e))
                  .toSet()
            : const {};
        devLog("Log WorkspaceDetailBloc: watchMember: data: $finalData");
        return currentState.copyWith(
          dataProject: currentState.dataProject.map((project) {
            return project.copyWith(
              dataProjectMember: currentState.dataUser.where((user) {
                return finalData.any(
                  (projectMember) =>
                      projectMember.projectId == project.dataProject.id &&
                      projectMember.userId == user.id,
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

  FutureOr<void> _onSelectedProject(
    WorkspaceDEtailEventSelectedProject event,
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
      workspaceId: currentState.dataWorkspace!.dataWorkspace.id,
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
    final edited = currentState.selectedProject!.copyWith(
      dataProject: original.dataProject.copyWith(
        name: event.name,
        end: event.end,
        start: event.start,
        type: event.type,
        totalContribut: event.contributor.length,
        status: event.status,
      ),
      dataProjectMember: event.contributor,
    );
    final data = await repo.updateProject(
      original: currentState.selectedProject!,
      edited: edited,
      role: "",
    );

    if (data != null) {
      emit(currentState.copyWith(error: data.error, failed: data.failed));
    }
  }

  Future<void> _onDeleteProject(
    WorkspaceDetailEventDeleteProject event,
    Emitter<WorkspaceDetailState> emit,
  ) async {
    add(WorkspaceDetailEventChangeStatus(status: EnumStatusState.synchronize));
    final data = await repo.deleteProject(event.idProject);
    if (data != null) {
      emit(
        (state as WorkspaceDetailStateLoaded).copyWith(
          error: data.error,
          failed: data.failed,
        ),
      );
    }
  }
}
