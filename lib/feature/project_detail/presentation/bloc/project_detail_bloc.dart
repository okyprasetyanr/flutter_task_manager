import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_label.dart';
import 'package:task_manager/shared/model/model_project_member.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/model/model_task.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectDetailRepository repo;
  ProjectDetailBloc(this.repo) : super(ProjectDetailStateInitial()) {
    on<ProjectDetailEventGetData>(_onGetData);
  }

  Future<void> _onGetData(
    ProjectDetailEventGetData event,
    Emitter<ProjectDetailState> emit,
  ) async {
    final currentState = state is ProjectDetailStateLoaded
        ? state as ProjectDetailStateLoaded
        : ProjectDetailStateLoaded();
    add(ProjectDetailEventChangeStatus(status: EnumStatusState.loading));
    final projectId = event.data ?? currentState.dataProject!.projectId;
    final data = await repo.getProjectDetail(projectId: projectId);
    emit(
      currentState.copyWith(
        dataLabelTask: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success]['label'] as List)
                  .map((e) => ModelLabel.fromJson(e))
                  .toList()
            : [],
        dataProject: event.data,
        dataProjectMember: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success]['project_member'] as List)
                  .map((e) => ModelProjectMember.fromJson(e))
                  .toList()
            : [],
        dataTask: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success]['task'] as List).map((e) {
                final subTask =
                    (data.$1[EnumFetchApiStatus.success]['sub_task'] as List)
                        .where((sub) => sub['task_id'] == e['id'])
                        .map((e) => ModelSubTask.fromJson(e))
                        .toList();

                return ModelTask.fromJson(e, subTask);
              }).toList()
            : [],

        error: data.$2.error,
        failed: data.$2.failed,
        noconnection: data.$2.noconnection,
        status: EnumStatusState.none,
      ),
    );
  }
}
