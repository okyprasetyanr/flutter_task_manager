import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_botshet_content.dart';
import 'package:task_manager/shared/common_widget/listview/custom_handler_list_v.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/style/icon_size.dart';
import 'package:task_manager/shared/style/text_size.dart';

class TaskDetailListSubTask extends StatelessWidget {
  const TaskDetailListSubTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Subtask", style: lv1TextStyleBold),
        const SizedBox(height: 5),
        Expanded(
          child: Material(
            color: AppPropertyColor.white,
            elevation: 2,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child:
                BlocSelector<
                  TaskDetailBloc,
                  TaskDetailState,
                  (Set<ModelSubTask>, EnumStatusState)
                >(
                  selector: (state) => state is TaskDetailStateLoaded
                      ? (state.task?.dataSubTask ?? const {}, state.status)
                      : (const {}, EnumStatusState.loading),
                  builder: (context, state) => CustomHandlerList<ModelSubTask>(
                    changeColor: AppPropertyColor.primary,
                    status: state.$2,
                    data: state.$1.toList(),
                    onOption: (data) {
                      final bloc = context.read<TaskDetailBloc>();
                      bloc.add(TaskDetailEventSelectedSubtask(data: data));
                      customBottomSheet(
                        context: context,
                        resetItemForm: () =>
                            bloc.add(TaskDetailEventResetSelected()),
                        content: (scrollController) => BlocProvider.value(
                          value: bloc,
                          child: TaskDetailBotshetContent(),
                        ),
                      );
                    },
                    smallSpace: true,
                    content: (data, _) => [
                      Row(
                        children: [
                          Text(data.title, style: lv05TextStyleWhite),
                          const Spacer(),
                          Material(
                            elevation: 2,
                            color: AppPropertyColor.white,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
        ),

        BlocSelector<TaskDetailBloc, TaskDetailState, Set<ModelSubTask>?>(
          selector: (state) =>
              state is TaskDetailStateLoaded ? state.task?.dataSubTask : null,
          builder: (context, state) {
            int totalTask = 0;
            int completedTask = 0;
            if (state != null) {
              if (state.isNotEmpty) {
                for (final task in state) {
                  if (task.isDone) {
                    completedTask++;
                    totalTask++;
                  } else {
                    totalTask++;
                  }
                }
              }
            }

            final dueDate = DateTime(2026, 7, 10);
            final today = DateTime.now();

            final remainingDays = dueDate.difference(today).inDays;
            final progress = totalTask == 0 ? 0.0 : completedTask / totalTask;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Project Progress", style: lv05TextStyleBold),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: lv05TextStyleBold,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: AppPropertyColor.greyLight,
                      valueColor: AlwaysStoppedAnimation(
                        AppPropertyColor.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18),
                      const SizedBox(width: 8),
                      Text.rich(
                        TextSpan(
                          style: lv05TextStyle,
                          children: [
                            TextSpan(
                              text: "$completedTask from $totalTask task is",
                              style: lv05TextStyle,
                            ),
                            TextSpan(
                              text: "\nDone",
                              style: lv05TextStyleBoldPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text("$remainingDays days left", style: lv05TextStyle),
              ],
            );
          },
        ),
      ],
    );
  }
}
