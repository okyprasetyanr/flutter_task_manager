import 'package:flutter/material.dart';
import 'package:task_manager/feature/shared_component/widget/base_layout/base_layout.dart';
import 'package:task_manager/feature/shared_component/widget/floating_button_add/floating_button_add.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_background.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_botshet_content.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_header.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_list_workspace.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_list_member.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_notification.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      uiPage: uiPage(),
      fab: FloatingButtonAdd<WorkspaceBloc>(
        content: (scrollController) =>
            WorkspaceBotshetContent(scrollController: scrollController),
      ),
      background: WorkspaceBackground(),
    );
  }

  Widget uiPage() {
    return Column(
      children: [
        WorkspaceHeader(),
        const SizedBox(height: 15),
        WorkspaceListMember(),
        const SizedBox(height: 10),
        WorkspaceNotification(),
        Expanded(child: WorkspaceListWorkspace()),
      ],
    );
  }
}
