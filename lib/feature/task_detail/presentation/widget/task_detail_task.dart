import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading_linear.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

class TaskDetailTask extends StatelessWidget {
  const TaskDetailTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TaskDetailBloc,
      TaskDetailState,
      (ModelTask?, EnumStatusState)
    >(
      selector: (state) => state is TaskDetailStateLoaded
          ? (state.task?.dataTask, state.status)
          : (null, EnumStatusState.loading),
      builder: (context, state) {
        if (state.$1 == null && state.$2 == EnumStatusState.loading) {
          return CustomLoadingLinear();
        } else if (state.$1 == null && state.$2 != EnumStatusState.loading) {
          return CustomTextEmpty(
            text: "Terjadi kesalahan, silahkan coba kembali!",
          );
        } else {
          final data = state.$1!;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data.title, style: lv1TextStyleBold),
                  Text(data.priority.text, style: lv1TextStyleBold),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start: ${HelperDateConvert.toDisplayUI(date: data.createdAt)}",
                    style: lv05TextStyleBold,
                  ),
                  Text(
                    "Due: ${HelperDateConvert.toDisplayUI(date: data.dueDate)}",
                    style: lv05TextStyleBoldRed,
                  ),
                ],
              ),
              const SizedBox(height: 3),
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
                  const SizedBox(height: 3),
                  Text(data.status.text, style: lv05TextStyle),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
