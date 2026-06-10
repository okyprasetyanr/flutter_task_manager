import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_bloc.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/header/custom_row_header.dart';
import 'package:task_manager/shared/widget/loading/custom_loading.dart';

class HistoryTaskHeader extends StatelessWidget {
  const HistoryTaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRowHeader(
      widgetLeft: Text('History Task', style: titleTextStyle),
      widgetRight:
          BlocSelector<
            HistoryTaskBloc,
            HistoryTaskState,
            (String?, EnumStatusState)
          >(
            selector: (state) => state is HistoryTaskStateLoaded
                ? (state.dataWorkspace?.workspaceName ?? "...", state.status)
                : (null, EnumStatusState.loading),
            builder: (context, state) => state.$2 == EnumStatusState.loading
                ? CustomLoading()
                : Text(
                    "${state.$1} Company",
                    style: lv1TextStyle,
                    textAlign: TextAlign.end,
                  ),
          ),
    );
  }
}
