import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/shared_component/widget/member_list/widget_member_list.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_botshet_content.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

class WorkspaceDetailListProject extends StatelessWidget {
  const WorkspaceDetailListProject({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceDetailBloc, WorkspaceDetailState>(
      listenWhen: (previous, current) =>
          previous is WorkspaceDetailStateLoaded &&
          current is WorkspaceDetailStateLoaded &&
          previous.initMember == null &&
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
            (Set<ModelProjectMerge>, EnumStatusState)
          >(
            selector: (state) => state is WorkspaceDetailStateLoaded
                ? (state.dataProject, state.status)
                : (const {}, EnumStatusState.loading),
            builder: (context, state) =>
                CustomListViewBuilderV<ModelProjectMerge>(
                  status: state.$2,
                  data: state.$1.toList(),
                  content: (data, status) => [
                    Text(data.dataProject.name, style: lv05TextStyle),
                    const SizedBox(height: 4),
                    Text(data.dataProject.type, style: lv05TextStyle),
                    const SizedBox(height: 4),
                    Text(
                      data.dataProject.status.text,
                      style: lv05TextStyle.copyWith(color: Colors.grey),
                    ),
                    Text(data.dataProject.createdBy, style: lv05TextStyle),
                    const SizedBox(height: 4),
                    Text(
                      HelperDateConvert.toDisplayUI(
                        date: data.dataProject.start,
                      ),
                      style: lv05TextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      HelperDateConvert.toDisplayUI(date: data.dataProject.end),
                      style: lv05TextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.dataProject.totalContribut.toString(),
                      style: lv05TextStyle,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 30,
                      child:
                          data.dataProjectMember.isEmpty &&
                              status == EnumStatusState.synchronize
                          ? const CustomLoading()
                          : data.dataProjectMember.isEmpty &&
                                status == EnumStatusState.none
                          ? const CustomTextEmpty()
                          : SharedWidgetMemberList(
                              data: data.dataProjectMember,
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
                  onEdit: (data) {
                    final bloc = context.read<WorkspaceDetailBloc>();
                    bloc.add(WorkspaceDetailEventSelectedProject(data: data));
                    return customBottomSheet(
                      context: context,
                      resetItemForm: () =>
                          bloc.add(WorkspaceDetailEventResetSelected()),
                      content: (scrollController) {
                        return BlocProvider.value(
                          value: bloc,
                          child: WorkspaceDetailBotshetContent(
                            scrollController: scrollController,
                          ),
                        );
                      },
                    );
                  },
                ),
          ),
    );
  }
}
