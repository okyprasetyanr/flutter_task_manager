import 'package:flutter/material.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project_detail_botshet_content.dart';
import 'package:task_manager/feature/shared_component/widget/base_layout/base_layout.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project_detail_header.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project_detail_member_progress.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project_detail_list_task.dart';
import 'package:task_manager/feature/project_detail/presentation/widget/project_detail_project.dart';
import 'package:task_manager/feature/shared_component/widget/floating_button_add/floating_button_add.dart';
import 'package:task_manager/shared/style/text_size.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({super.key});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      uiPage: uiPage(),
      fab: FloatingButtonAdd<ProjectDetailBloc>(
        content: (scrollController) {
          return ProjectDetailBotshetContent(
            scrollController: scrollController,
          );
        },
      ),
    );
  }

  Widget uiPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectDetailHeader(),
        const SizedBox(height: 10),
        ProjectDetailProject(),
        const SizedBox(height: 10),
        Text("Member", style: lv1TextStyleBold),
        const SizedBox(height: 5),
        Expanded(flex: 2, child: ProjectDetailListMember()),
        const SizedBox(height: 10),
        Text("Task", style: lv1TextStyleBold),
        const SizedBox(height: 5),
        Expanded(flex: 5, child: ProjectDetailListTask()),
      ],
    );
  }
}
