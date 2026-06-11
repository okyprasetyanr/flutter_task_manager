import 'package:flutter/material.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_button_comment.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_header.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_label.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_sub_task.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_task.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final controller = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseLayout(uiPage: uiPage());
  }

  Widget uiPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskDetailHeader(),
        TaskDetailTask(),
        TaskDetailListLabel(),
        Expanded(child: TaskDetailListSubTask()),
        TaskDetailButtonComment(controller: controller, keyForm: _keyForm),
      ],
    );
  }
}
