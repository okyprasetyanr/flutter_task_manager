import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/header/custom_row_header.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';

class ProjectDetailHeader extends StatelessWidget {
  const ProjectDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRowHeader(
      widgetLeft: Text('Project Detail', style: titleTextStyle),
      widgetRight: BlocSelector<ProjectDetailBloc, ProjectDetailState, String?>(
        selector: (state) => state is ProjectDetailStateLoaded
            ? state.dataProject?.dataProject.name
            : null,
        builder: (context, state) => state != null
            ? Text(
                "Project $state",
                style: lv1TextStyle,
                textAlign: TextAlign.end,
              )
            : SizedBox(height: 20, width: 20, child: CustomLoading()),
      ),
    );
  }
}
