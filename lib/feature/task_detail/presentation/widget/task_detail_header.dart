import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/header/custom_row_header.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';

class TaskDetailHeader extends StatelessWidget {
  const TaskDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRowHeader(
      widgetLeft: Text('Task Detail', style: titleTextStyle),
      widgetRight:
          BlocSelector<
            TaskDetailBloc,
            TaskDetailState,
            (String?, EnumStatusState)
          >(
            selector: (state) => state is TaskDetailStateLoaded
                ? (state.dataTask?.title ?? "...", state.status)
                : (null, EnumStatusState.loading),
            builder: (context, state) => state.$2 == EnumStatusState.loading
                ? CustomLoading()
                : Text(
                    "${state.$1} Task",
                    style: lv1TextStyle,
                    textAlign: TextAlign.end,
                  ),
          ),
    );
  }
}
