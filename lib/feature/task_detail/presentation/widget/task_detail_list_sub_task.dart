import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_botshet_content.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/style/icon_size.dart';
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
          ? (state.task?.dataSubTask ?? const {}, state.status)
          : (const {}, EnumStatusState.loading),
      builder: (context, state) => CustomListViewBuilderV<ModelSubTask>(
        status: state.$2,
        data: state.$1.toList(),
        onOption: (data) {
          final bloc = context.read<TaskDetailBloc>();
          bloc.add(TaskDetailEventSelectedSubtask(data: data));
          customBottomSheet(
            context: context,
            resetItemForm: () => bloc.add(TaskDetailEventResetSelected()),
            content: (scrollController) => BlocProvider.value(
              value: bloc,
              child: TaskDetailBotshetContent(),
            ),
          );
        },
        content: (data, _) => [
          Card(
            elevation: 2,
            color: AppPropertyColor.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(data.title, style: lv05TextStyle),
                      const Spacer(),
                      Text(
                        data.isDone ? "Done" : "On Progress",
                        style: lv05TextStyle,
                      ),
                      const SizedBox(width: 10),
                      data.isDone
                          ? Icon(
                              Icons.check_circle_outline_rounded,
                              size: lv2IconSize,
                              color: AppPropertyColor.primary,
                            )
                          : Icon(
                              Icons.radio_button_unchecked_rounded,
                              size: lv2IconSize,
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
