import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/model/model_comment.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class TaskDetailListComment extends StatelessWidget {
  final ScrollController controller;
  const TaskDetailListComment({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TaskDetailBloc,
      TaskDetailState,
      (Set<ModelComment>, EnumStatusState, Set<ModelUser>)
    >(
      selector: (state) => state is TaskDetailStateLoaded
          ? (state.dataComment, state.status, state.dataUser)
          : (const {}, EnumStatusState.loading, const {}),
      builder: (context, state) => CustomListViewBuilderV<ModelComment>(
        controller: controller,
        status: state.$2,
        data: state.$1.toList(),
        content: (data, _) => [
          Text(
            state.$3.firstWhere((element) => element.id == data.userId).name,
            style: lv1TextStyle,
            textAlign: TextAlign.start,
          ),
          Text(data.content),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                HelperDateConvert.toDisplayUI(date: data.createdAt),
                style: lv05TextStyle,
              ),
              Text(
                HelperDateConvert.toDisplayUI(date: data.createdAt),
                style: lv05TextStyle,
              ),
            ],
          ),
        ],
        onPressed: (data) => {},
      ),
    );
  }
}
