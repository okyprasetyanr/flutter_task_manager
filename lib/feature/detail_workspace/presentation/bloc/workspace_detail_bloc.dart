import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/detail_workspace/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/feature/detail_workspace/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/detail_workspace/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_project.dart';
import 'package:task_manager/shared/model/model_workspace_member.dart';

class WorkspaceDetailBloc
    extends Bloc<WorkspaceDetailEvent, WorkspaceDetailState> {
  final WorkspaceDetailRepository repo;

  WorkspaceDetailBloc(this.repo) : super(WorkspaceDetailStateInitial()) {
    on<WorkspaceDetailEventGetData>(_onGetData);
    on<WorkspaceDetailEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onGetData(
    WorkspaceDetailEventGetData event,
    Emitter<WorkspaceDetailState> emit,
  ) async {
    final currentState = state is WorkspaceDetailStateLoaded
        ? state as WorkspaceDetailStateLoaded
        : WorkspaceDetailStateLoaded();
    add(WorkspaceDetailEventChangeStatus(status: EnumStatusState.loading));
    final data = await repo.getWorkspaceDetai(
      workspaceId: event.data.workspaceId,
      companyId: event.data.companyId,
    );
    emit(
      currentState.copyWith(
        dataWorkspace: event.data,
        dataProject: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success]['workspace_project'] as List)
                  .map((e) => ModelProject.fromJson(e))
                  .toList()
            : [],
        dataWorkspaceMember: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success]['workspace_member'] as List)
                  .map((e) => ModelWorkspaceMember.fromJson(e))
                  .toList()
            : [],
        error: data.$2.error,
        failed: data.$2.failed,
        noconnection: data.$2.noconnection,
        status: EnumStatusState.none,
      ),
    );
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
}
