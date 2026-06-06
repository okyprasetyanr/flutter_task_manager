import 'package:flutter/material.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/detail_workspace/presentation/widget/workspace_detail_header.dart';
import 'package:task_manager/feature/detail_workspace/presentation/widget/workspace_detail_list_project.dart';

class WorkspaceDetailPage extends StatefulWidget {
  const WorkspaceDetailPage({super.key});

  @override
  State<WorkspaceDetailPage> createState() => _WorkspaceDetailPageState();
}

class _WorkspaceDetailPageState extends State<WorkspaceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(uiPage: uiPage());
  }

  Widget uiPage() {
    return Column(
      children: [
        WorkspaceDetailHeader(),
        Expanded(child: WorkspaceDetailListProject()),
      ],
    );
  }
}
