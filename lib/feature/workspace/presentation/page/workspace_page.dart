import 'package:flutter/material.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_button_add.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_header.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_list_workspace.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
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
        Expanded(
          child: WorkspaceListWorkspace(
            nameController: nameController,
            descriptionController: descriptionController,
            keyForm: _keyForm,
          ),
        ),
        WorkspaceButtonAdd(
          nameController: nameController,
          descriptionController: descriptionController,
          keyForm: _keyForm,
        ),
      ],
    );
  }
}
