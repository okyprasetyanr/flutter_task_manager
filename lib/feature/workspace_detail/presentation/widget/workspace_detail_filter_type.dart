import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_user_project.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_h.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WorkspaceDetailFilterType extends StatelessWidget {
  const WorkspaceDetailFilterType({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppPropertyColor.white,
            AppPropertyColor.white.withValues(alpha: 0.5),
            AppPropertyColor.white.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkspaceDetailUserProject(),
          const SizedBox(height: 10),
          Text("Project Type", style: lv1TextStyleBold),
          const SizedBox(height: 5),
          BlocSelector<
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
          ),
        ],
      ),
    );
  }
}
