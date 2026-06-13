import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_label.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/model/model_task.dart';
import 'package:task_manager/shared/model/model_user.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectDetailRepository repo;
  ProjectDetailBloc(this.repo) : super(ProjectDetailStateInitial()) {
    on<ProjectDetailEventGetData>(_onGetData);
    on<ProjectDetailEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onGetData(
    ProjectDetailEventGetData event,
    Emitter<ProjectDetailState> emit,
  ) async {
    final currentState = state is ProjectDetailStateLoaded
        ? state as ProjectDetailStateLoaded
        : ProjectDetailStateLoaded();
    add(ProjectDetailEventChangeStatus(status: EnumStatusState.loading));
    final projectId = event.data?.id ?? currentState.dataProject!.id;
    final data = await repo.getProjectDetail(projectId: projectId);
    emit(
      currentState.copyWith(
        dataLabelTask: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success]['label'] as List)
                  .map((e) => ModelLabel.fromJson(e))
                  .toList()
            : const [],
        dataProject: event.data ?? currentState.dataProject,
        dataProjectMember: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success]['project_member'] as List)
                  .map((e) => ModelUser.fromJson(e))
                  .toList()
            : const [],
        dataTask: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success]['task'] as List).map((e) {
                final subTask =
                    (data.$1[EnumFetchApiStatus.success]['sub_task'] as List)
                        .where(
                          (sub) =>
                              sub[EnumSubTask.taskId.value] ==
                              e[EnumTask.id.value],
                        )
                        .map((e) => ModelSubTask.fromJson(e))
                        .toList();
                List<ModelLabel> label = const [];

                for (final idLabelTask in e[EnumTask.labelIds.value] as List) {
                  for (final labelData
                      in (data.$1[EnumFetchApiStatus.success]['label']
                          as List)) {
                    if (idLabelTask == labelData[EnumLabel.id.value]) {
                      label.add(ModelLabel.fromJson(labelData));
                    }
                  }
                }

                return ModelTask.fromJson(
                  data: e,
                  subTask: subTask,
                  label: label,
                );
              }).toList()
            : const [],

        error: data.$2.error,
        failed: data.$2.failed,
        noconnection: data.$2.noconnection,
        status: EnumStatusState.none,
      ),
    );
  }

  FutureOr<void> _onChangeStatus(
    ProjectDetailEventChangeStatus event,
    Emitter<ProjectDetailState> emit,
  ) {
    emit(
      (state is ProjectDetailStateLoaded
              ? state as ProjectDetailStateLoaded
              : ProjectDetailStateLoaded())
          .copyWith(status: event.status),
    );
  }
}
