import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/widget/member_list/widget_member_list.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_botshet_content.dart';
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
    return BlocSelector<
      WorkspaceDetailBloc,
      WorkspaceDetailState,
      (Set<ModelProjectMerge>, EnumStatusState, Set<ModelUser>)
    >(
      selector: (state) => state is WorkspaceDetailStateLoaded
          ? (state.dataProject, state.status, state.dataUser)
          : (const {}, EnumStatusState.loading, const {}),
      builder: (context, state) => CustomListViewBuilderV<ModelProjectMerge>(
        status: state.$2,
        data: state.$1.toList(),
        content: (data, status) => [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.dataProject.name, style: lv1TextStyleBold),
              Text(data.dataProject.type, style: lv1TextStyleBold),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Start: ${HelperDateConvert.toDisplayUI(date: data.dataProject.start)}",
                style: lv05TextStyleBold,
              ),
              Text(
                "Due: ${HelperDateConvert.toDisplayUI(date: data.dataProject.end)}",
                style: lv05TextStyleBoldRed,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.dataProject.status.text, style: lv05TextStyle),
              Text(
                state.$3
                    .firstWhere(
                      (element) => element.id == data.dataProject.createdBy,
                    )
                    .name,
                style: lv05TextStyle,
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            "Contributor: ${data.dataProject.totalContribut.toString()}",
            style: lv05TextStyle,
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            child:
                data.dataMember.isEmpty && status == EnumStatusState.synchronize
                ? const CustomLoading()
                : data.dataMember.isEmpty && status == EnumStatusState.none
                ? const CustomTextEmpty()
                : SharedWidgetMemberList(
                    data: state.$3
                        .where(
                          (element) => data.dataMember
                              .map((e) => e.userId)
                              .contains(element.id),
                        )
                        .toSet(),
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
        onOption: (data) {
          final bloc = context.read<WorkspaceDetailBloc>();
          bloc.add(WorkspaceDetailEventSelectedProject(data: data));
          return customBottomSheet(
            context: context,
            resetItemForm: () => bloc.add(WorkspaceDetailEventResetSelected()),
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
    );
  }
}
