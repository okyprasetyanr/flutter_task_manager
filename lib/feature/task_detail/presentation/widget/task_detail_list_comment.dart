import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/task_detail/domain/model/model_comment.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class TaskDetailListComment extends StatelessWidget {
  final ScrollController scrollController;
  const TaskDetailListComment({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final dataId = ValueNotifier<String>("");
    return BlocSelector<
      TaskDetailBloc,
      TaskDetailState,
      (Set<ModelComment>, EnumStatusState, Set<ModelUser>)
    >(
      selector: (state) => state is TaskDetailStateLoaded
          ? (state.dataComment, state.status, state.dataUser)
          : (const {}, EnumStatusState.loading, const {}),
      builder: (context, state) => CustomListViewBuilderV<ModelComment>(
        controller: scrollController,
        status: state.$2,
        data: state.$1.toList(),
        onOption: (data) =>
            data.isOwned! && state.$2 != EnumStatusState.synchronize
            ? () {
                dataId.value = data.id;
                context.read<TaskDetailBloc>().add(
                  TaskDetailEventDeleteComment(commentId: data.id),
                );
              }()
            : null,
        specificOption: (data) => data.isOwned!,
        changeOptionIcon: (data) => ValueListenableBuilder(
          valueListenable: dataId,
          builder: (context, value, child) => value == data.id
              ? const SizedBox(height: 20, width: 20, child: CustomLoading())
              : Icon(Icons.delete_rounded, color: AppPropertyColor.red),
        ),
        content: (data, _) => [
          Align(
            alignment: data.isOwned!
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              state.$3.firstWhere((element) => element.id == data.userId).name,
              style: lv05TextStyle,
            ),
          ),
          Align(
            alignment: data.isOwned!
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(data.content, style: lv1TextStyle),
          ),

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
