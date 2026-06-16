import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/model/model_project.dart';
import 'package:task_manager/shared/model/model_project_member.dart';

class WorkspaceDetailBloc
    extends Bloc<WorkspaceDetailEvent, WorkspaceDetailState> {
  final WorkspaceDetailRepository repo;

  WorkspaceDetailBloc(this.repo) : super(WorkspaceDetailStateInitial()) {
    on<WorkspaceDetailEventWatch>(_onWatch);
    on<WorkspaceDetailEventWatchMember>(_onWatchMember);
    on<WorkspaceDetailEventChangeStatus>(_onChangeStatus);
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
      repo.watchProject(workspaceId: dataWorkspace.id),
      onData: (data) {
        return currentState.copyWith(
          dataWorkspace: dataWorkspace,
          dataUser: repo.getUser(),
          dataProject: data.$1.containsKey(EnumFetchApiStatus.success)
              ? (data.$1[EnumFetchApiStatus.success] as List)
                    .map((e) => ModelProject.fromJson(e))
                    .toList()
              : const [],
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
      "Log WorkspaceDetailBloc: watchMember: listId: ${(state as WorkspaceDetailStateLoaded).dataProject.map((e) => e.id).toList()}",
    );
    await emit.forEach(
      repo.watchProjectMember(
        projectIds: (state as WorkspaceDetailStateLoaded).dataProject
            .map((e) => e.id)
            .toList(),
      ),
      onData: (data) {
        List<ModelProjectMember> finalData =
            data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelProjectMember.fromJson(e))
                  .toList()
            : const [];
        devLog("Log WorkspaceDetailBloc: watchMember: data: $finalData");
        return currentState.copyWith(
          dataProject: currentState.dataProject.map((project) {
            return project.copyWith(
              dataMember: currentState.dataUser.where((user) {
                return finalData.any(
                  (projectMember) =>
                      projectMember.projectId == project.id &&
                      projectMember.userId == user.id,
                );
              }).toList(),
            );
          }).toList(),
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
}
