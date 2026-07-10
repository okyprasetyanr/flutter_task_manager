import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/common_widget/listview/custom_handler_list_v.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading_linear.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/task_detail/domain/model/model_comment.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/style/text_size.dart';

class TaskDetailListComment extends StatelessWidget {
  final ScrollController? scrollController;
  final int? limit;
  const TaskDetailListComment({super.key, this.scrollController, this.limit});

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
      builder: (context, state) => CustomHandlerList<ModelComment>(
        limit: limit,
        reverse: limit != null,
        isListView: limit == null,
        smallSpace: true,
        changeColor: AppPropertyColor.primary,
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
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CustomLoadingLinear(),
                )
              : Icon(Icons.delete_rounded, color: AppPropertyColor.red),
        ),
        content: (data, _) => [
          Align(
            alignment: data.isOwned!
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              state.$3.firstWhere((element) => element.id == data.userId).name,
              style: lv1TextStyleWhiteBold,
            ),
          ),
          const SizedBox(height: 5),
          Material(
            color: AppPropertyColor.white,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Align(
                alignment: data.isOwned!
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(data.content, style: lv1TextStyle),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                HelperDateConvert.toDisplayUI(date: data.createdAt),
                style: lv05TextStyleWhite,
              ),
              if (data.createdAt != data.updatedAt)
                Text(
                  "Updated: ${HelperDateConvert.toDisplayUI(date: data.createdAt)}",
                  style: lv05TextStyleWhite,
                ),
            ],
          ),
        ],
        onPressed: (data) => {},
      ),
    );
  }
}
