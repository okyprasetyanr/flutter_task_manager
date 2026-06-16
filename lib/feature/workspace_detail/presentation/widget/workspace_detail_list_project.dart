import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_project_member.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/model/model_project.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/listview/custom_list_view_builder_v.dart';
import 'package:task_manager/shared/widget/loading/custom_loading.dart';
import 'package:task_manager/shared/widget/text/custom_text_empty.dart';

class WorkspaceDetailListProject extends StatelessWidget {
  const WorkspaceDetailListProject({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceDetailBloc, WorkspaceDetailState>(
      listenWhen: (previous, current) =>
          previous is WorkspaceDetailStateLoaded &&
          current is WorkspaceDetailStateLoaded &&
          previous.initMember == false &&
          current.initMember == true,
      listener: (context, state) {
        if (state is WorkspaceDetailStateLoaded) {
          context.read<WorkspaceDetailBloc>().add(
            WorkspaceDetailEventWatchMember(),
          );
        }
      },
      child:
          BlocSelector<
            WorkspaceDetailBloc,
            WorkspaceDetailState,
            (List<ModelProject>, EnumStatusState)
          >(
            selector: (state) => state is WorkspaceDetailStateLoaded
                ? (state.dataProject, state.status)
                : (const [], EnumStatusState.loading),
            builder: (context, state) => CustomListViewBuilderV<ModelProject>(
              status: state.$2,
              data: state.$1,
              content: (data, status) => [
                Text(data.name, style: lv05TextStyle),
                const SizedBox(height: 4),
                Text(data.type, style: lv05TextStyle),
                const SizedBox(height: 4),
                Text(
                  data.status.text,
                  style: lv05TextStyle.copyWith(color: Colors.grey),
                ),
                Text(data.createdId, style: lv05TextStyle),
                const SizedBox(height: 4),
                Text(
                  HelperDateConvert.toDisplayUI(date: data.start),
                  style: lv05TextStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  HelperDateConvert.toDisplayUI(date: data.end),
                  style: lv05TextStyle,
                ),
                const SizedBox(height: 4),
                Text(data.totalContribut.toString(), style: lv05TextStyle),
                const SizedBox(height: 4),
                SizedBox(
                  height: 30,
                  child:
                      data.dataMember == null &&
                          status == EnumStatusState.synchronize
                      ? const CustomLoading()
                      : (data.dataMember?.isEmpty ?? true) &&
                            status == EnumStatusState.none
                      ? const CustomTextEmpty()
                      : WorkspaceDetailProjectMember(
                          data: data.dataMember ?? const [],
                          status: status,
                        ),
                ),
              ],
              onPressed: (data) => {
                RoutesNavigator(
                  context: context,
                  routeName: RoutesEnum.projectDetail,
                  replace: false,
                  arguments: {'dataTransfered': data},
                ).navigate(),
              },
            ),
          ),
    );
  }
}
