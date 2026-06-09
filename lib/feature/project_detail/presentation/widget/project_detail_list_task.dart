import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project_detail_list_sub_task.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/model/model_task.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/listview/custom_list_view_builder.dart';

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
            (List<ModelTask>, EnumStatusState)
          >(
            selector: (state) => state is ProjectDetailStateLoaded
                ? (state.dataTask, state.status)
                : ([], EnumStatusState.loading),
            builder: (context, state) {
              return CustomListViewBuilder(
                status: state.$2,
                data: state.$1,
                content: (data) => [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.title, style: lv05TextStyle),
                      Text(data.priority.text, style: lv05TextStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        HelperDateConvert.toDisplayUI(date: data.createdAt),
                        style: lv05TextStyle,
                      ),
                      Text(
                        HelperDateConvert.toDisplayUI(date: data.dueDate),
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
                            HelperDateConvert.toDisplayUI(date: data.updatedAt),
                            style: lv05TextStyle,
                          ),
                        ],
                      ),

                      Text(data.status.text, style: lv05TextStyle),
                    ],
                  ),
                  ProjectDetailListSubTask(data: data.subTask),
                ],
                onPressed: (data) => {},
              );
            },
          ),
    );
  }
}
