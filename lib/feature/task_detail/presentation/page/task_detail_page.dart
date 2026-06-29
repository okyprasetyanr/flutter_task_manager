import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/shared_component/widget/base_layout/base_layout.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_botshet_content.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_button_comment.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_header.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_label.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_sub_task.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_task.dart';
import 'package:task_manager/shared/common_widget/multi_fab/custom_multi_fab.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/model/model_fab.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      uiPage: uiPage(),
      fab: CustomMultiFab(
        items: [
          CustomFabItem(
            icon: Icons.comment_rounded,
            title: "Comment",
            onTap: () => customBottomSheet(
              context: context,
              resetItemForm: () {},
              content: (scrollController) {
                return BlocProvider.value(
                  value: context.read<TaskDetailBloc>(),
                  child: TaskDetailButtonComment(
                    scrollController: scrollController,
                  ),
                );
              },
            ),
          ),
          CustomFabItem(
            icon: Icons.add,
            title: "Add",
            onTap: () => customBottomSheet(
              context: context,
              resetItemForm: () {},
              content: (scrollController) {
                return BlocProvider.value(
                  value: context.read<TaskDetailBloc>(),
                  child: TaskDetailBotshetContent(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget uiPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskDetailHeader(),
        const SizedBox(height: 10),
        TaskDetailTask(),
        const SizedBox(height: 5),
        TaskDetailListLabel(),
        const SizedBox(height: 5),
        Expanded(child: TaskDetailListSubTask()),
      ],
    );
  }
}
