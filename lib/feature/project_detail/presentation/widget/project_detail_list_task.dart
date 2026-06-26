import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project_detail_botshet_content.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project_detail_list_sub_task.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_h.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class ProjectDetailListTask extends StatefulWidget {
  const ProjectDetailListTask({super.key});

  @override
  State<ProjectDetailListTask> createState() => _ProjectDetailListTaskState();
}

class _ProjectDetailListTaskState extends State<ProjectDetailListTask> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppPropertyColor.white,
      child:
          BlocSelector<
            ProjectDetailBloc,
            ProjectDetailState,
            (Set<ModelTaskMerge>, Set<ModelLabel>, EnumStatusState)
          >(
            selector: (state) => state is ProjectDetailStateLoaded
                ? (state.dataTask, state.dataLabel, state.status)
                : (const {}, const {}, EnumStatusState.loading),
            builder: (context, state) {
              return CustomListViewBuilderV(
                onOption: (data) {
                  context.read<ProjectDetailBloc>().add(
                    ProjectDetailEventSelectedData(selectedDate: data),
                  );
                  return customBottomSheet(
                    context: context,
                    resetItemForm: () {
                      context.read<ProjectDetailBloc>().add(
                        ProjectDetailEventResetSelected(),
                      );
                    },
                    content: (scrollController) {
                      final bloc = context.read<ProjectDetailBloc>();
                      return BlocProvider.value(
                        value: bloc,
                        child: ProjectDetailBotshetContent(
                          scrollController: scrollController,
                        ),
                      );
                    },
                  );
                },
                status: state.$3,
                data: state.$1.toList(),
                content: (data, status) => [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.dataTask.title, style: lv05TextStyle),
                      Text(data.dataTask.priority.text, style: lv05TextStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        HelperDateConvert.toDisplayUI(
                          date: data.dataTask.createdAt,
                        ),
                        style: lv05TextStyle,
                      ),
                      Text(
                        HelperDateConvert.toDisplayUI(
                          date: data.dataTask.dueDate,
                        ),
                        style: lv05TextStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Updated: ", style: lv05TextStyle),
                          Text(
                            HelperDateConvert.toDisplayUI(
                              date: data.dataTask.updatedAt,
                            ),
                            style: lv05TextStyle,
                          ),
                        ],
                      ),
                      Text(data.dataTask.status.text, style: lv05TextStyle),
                    ],
                  ),
                  BlocSelector<
                    ProjectDetailBloc,
                    ProjectDetailState,
                    Set<ModelUser>
                  >(
                    selector: (state) => state is ProjectDetailStateLoaded
                        ? state.dataUser
                        : const {},
                    builder: (context, state) => Text(
                      "Assignee: ${state.firstWhere((element) => element.id == data.dataTask.assigneeId).name}",
                      style: lv05TextStyle,
                    ),
                  ),
                  CustomListViewBuilderH<ModelLabel>(
                    data: data.dataTaskLabel.toList(),
                    status: status,
                    getName: (data) => data.name,
                  ),
                  ProjectDetailListSubTask(
                    data: data.dataSubTask,
                    status: status,
                  ),
                ],
                onPressed: (data) => {
                  RoutesNavigator(
                    context: context,
                    routeName: RoutesEnum.taskDetail,
                    replace: false,
                    arguments: {'dataTransfered': (data, state.$2)},
                  ).navigate(),
                },
              );
            },
          ),
    );
  }
}
