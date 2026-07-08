import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_h.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceDetailFilterType extends StatelessWidget {
  const WorkspaceDetailFilterType({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WorkspaceDetailBloc,
      WorkspaceDetailState,
      (Set<String>, EnumStatusState, String?)
    >(
      selector: (state) => state is WorkspaceDetailStateLoaded
          ? (state.dataType, state.status, state.selectedType)
          : ({}, EnumStatusState.loading, null),
      builder: (context, state) {
        return CustomListViewBuilderH(
          condition: (data) => data == state.$3,
          status: state.$2,
          data: state.$1.toList(),
          getName: (data) => data,
          onPress: (data) {
            devLog(
              "Log WorkspaceDetailFilteredType: selectedFilter: $data, selectedFromState: ${state.$3}",
            );
            context.read<WorkspaceDetailBloc>().add(
              WorkspaceDetailEventSelectedFilterType(
                type: data == state.$3 ? null : data,
              ),
            );
          },
        );
      },
    );
  }
}
