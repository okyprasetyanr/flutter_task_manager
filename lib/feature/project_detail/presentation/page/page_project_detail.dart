import 'package:flutter/material.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/member/ui_project_member_layout.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project/ui_project_layout.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/task/ui_project_task_layout.dart';

class PageProjectDetail extends StatefulWidget {
  const PageProjectDetail({super.key});

  @override
  State<PageProjectDetail> createState() => _PageProjectDetailState();
}

class _PageProjectDetailState extends State<PageProjectDetail> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(uiPage: uiPage());
  }

  Widget uiPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Expanded(child: UIProjectLayout()),
          Expanded(flex: 4, child: UiProjectMemberLayout()),
          Expanded(flex: 8, child: UiProjectTaskLayout()),
        ],
      ),
    );
  }
}
