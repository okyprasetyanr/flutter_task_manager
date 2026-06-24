import 'package:flutter/material.dart';
import 'package:task_manager/feature/shared_component/widget/base_layout/base_layout.dart';
import 'package:task_manager/feature/shared_component/widget/floating_button_add/floating_button_add.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_botshet_content.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_button_comment.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_header.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_label.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_sub_task.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_task.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      uiPage: uiPage(),
      fab: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingButtonAdd<TaskDetailBloc>(
            content: (scrollController) => TaskDetailBotshetContent(),
          ),
          TaskDetailButtonComment(),
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
        TaskDetailListLabel(),
        Expanded(child: TaskDetailListSubTask()),
      ],
    );
  }
}
