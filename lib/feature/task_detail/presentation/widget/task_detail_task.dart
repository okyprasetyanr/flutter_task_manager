import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/model/model_label.dart';
import 'package:task_manager/shared/model/model_task.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

class TaskDetailTask extends StatelessWidget {
  const TaskDetailTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TaskDetailBloc,
      TaskDetailState,
      (ModelTask?, Set<ModelLabel>, EnumStatusState)
    >(
      selector: (state) => state is TaskDetailStateLoaded
          ? (state.dataTask, state.dataLabel, state.status)
          : (null, const {}, EnumStatusState.loading),
      builder: (context, state) {
        if (state.$1 == null && state.$3 == EnumStatusState.loading) {
          return CustomLoading();
        } else if (state.$1 == null && state.$3 != EnumStatusState.loading) {
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
            ],
          );
        }
      },
    );
  }
}
