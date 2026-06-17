import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class TaskDetailListSubTask extends StatelessWidget {
  const TaskDetailListSubTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TaskDetailBloc,
      TaskDetailState,
      (Set<ModelSubTask>, EnumStatusState)
    >(
      selector: (state) => state is TaskDetailStateLoaded
          ? (state.dataSubTask, state.status)
          : (const {}, EnumStatusState.loading),
      builder: (context, state) => CustomListViewBuilderV<ModelSubTask>(
        status: state.$2,
        data: state.$1.toList(),
        content: (data, _) => [
          Card(
            elevation: 2,
            color: AppPropertyColor.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.title, style: lv05TextStyle),
                      Text(
                        data.isDone ? "Done" : "On Progress",
                        style: lv05TextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        onPressed: (data) => {},
      ),
    );
  }
}
