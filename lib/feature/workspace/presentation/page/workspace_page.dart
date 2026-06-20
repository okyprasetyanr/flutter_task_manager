import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/shared_component/widget/floating_button_add/floating_button_add.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_botshet_content.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_header.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_list_workspace.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  @override
  void initState() {
    context.read<WorkspaceBloc>().add(WorkspaceEventWatchMessage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(uiPage: uiPage());
  }

  Widget uiPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        WorkspaceHeader(),
        const SizedBox(height: 15),
        Expanded(child: WorkspaceListWorkspace()),
        FloatingButtonAdd<WorkspaceBloc>(
          content: (scrollController) =>
              WorkspaceBotshetContent(scrollController: scrollController),
        ),
      ],
    );
  }
}
