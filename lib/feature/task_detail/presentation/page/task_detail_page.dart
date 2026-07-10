import 'package:flutter/material.dart';
import 'package:task_manager/feature/shared_component/helper/widget/base_layout/shared_base_layout.dart';
import 'package:task_manager/feature/shared_component/helper/widget/floating_button_add/shared_floating_button_add.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_botshet_content.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_comment_summary.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_header.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_sub_task.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_task.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedBaseLayout(
      uiPage: uiPage(),
      fab: SharedFloatingButtonAdd<TaskDetailBloc>(
        content: (scrollController) => TaskDetailBotshetContent(),
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
        Expanded(child: TaskDetailListSubTask()),
        const SizedBox(height: 10),
        TaskDetailCommentSummary(),
      ],
    );
  }
}
