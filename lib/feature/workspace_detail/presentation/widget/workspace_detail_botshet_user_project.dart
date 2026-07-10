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
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading_linear.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WorkspaceDetailBotshetUserProject extends StatefulWidget {
  final ScrollController scrollController;
  const WorkspaceDetailBotshetUserProject({
    super.key,
    required this.scrollController,
  });

  @override
  State<WorkspaceDetailBotshetUserProject> createState() =>
      _WorkspaceDetailBotshetUserProjectState();
}

class _WorkspaceDetailBotshetUserProjectState
    extends State<WorkspaceDetailBotshetUserProject> {
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Joined Projects", style: titleTextStyle),
          const SizedBox(height: 10),
          CustomTextField(
            controller: searchController,
            label: "Project Name",
            onChanged: (value) => context.read<WorkspaceDetailBloc>().add(
              WorkspaceDetailEventSearchUserProject(search: value),
            ),
          ),
          Expanded(
            child:
                BlocSelector<
                  WorkspaceDetailBloc,
                  WorkspaceDetailState,
                  (Set<ModelProjectMerge>, Set<ModelUser>, ModelUser?)
                >(
                  selector: (state) => state is WorkspaceDetailStateLoaded
                      ? (
                          state.filteredUserAssignedProject,
                          state.dataUser,
                          state.dataAccount,
                        )
                      : ({}, {}, null),
                  builder: (context, state) {
                    return CustomListViewBuilderV<ModelProjectMerge>(
                      controller: widget.scrollController,
                      status: EnumStatusState.none,
                      data: state.$1.toList(),
                      content: (data, status) => [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.dataProject.name,
                              style: lv1TextStyleBold,
                            ),
                            Text(
                              data.dataProject.type.text,
                              style: lv1TextStyleBold,
                            ),
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
                            Text(
                              data.dataProject.status.text,
                              style: lv05TextStyle,
                            ),
                            Text(
                              state.$2
                                  .firstWhere(
                                    (element) =>
                                        element.id ==
                                        data.dataProject.createdBy,
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
                              data.dataMember.isEmpty &&
                                  status == EnumStatusState.synchronize
                              ? const CustomLoadingLinear()
                              : data.dataMember.isEmpty &&
                                    status == EnumStatusState.none
                              ? const CustomTextEmpty()
                              : SharedWidgetMemberList(
                                  hightlightUser: state.$3,
                                  data: state.$2
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
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
