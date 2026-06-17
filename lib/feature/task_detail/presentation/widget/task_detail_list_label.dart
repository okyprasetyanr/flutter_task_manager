import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_label.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_h.dart';

class TaskDetailListLabel extends StatelessWidget {
  const TaskDetailListLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TaskDetailBloc,
      TaskDetailState,
      (Set<ModelLabel>, EnumStatusState)
    >(
      selector: (state) => state is TaskDetailStateLoaded
          ? (state.dataLabel, state.status)
          : (const {}, EnumStatusState.loading),
      builder: (context, state) => CustomListViewBuilderH<ModelLabel>(
        data: state.$1.toList(),
        status: state.$2,
        getName: (data) => data.name,
      ),
    );
  }
}
