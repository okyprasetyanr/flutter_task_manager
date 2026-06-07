import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/model/model_project.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/listview/custom_list_view_builder.dart';

class WorkspaceDetailListProject extends StatelessWidget {
  const WorkspaceDetailListProject({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WorkspaceDetailBloc,
      WorkspaceDetailState,
      (List<ModelProject>, EnumStatusState)
    >(
      selector: (state) => state is WorkspaceDetailStateLoaded
          ? (state.dataProject, state.status)
          : ([], EnumStatusState.loading),
      builder: (context, state) => CustomListViewBuilder<ModelProject>(
        status: state.$2,
        data: state.$1,
        content: (data) => [
          Text(data.projectName, style: lv05TextStyle),
          const SizedBox(height: 4),
          Text(data.projectType, style: lv05TextStyle),
          const SizedBox(height: 4),
          Text(
            EnumProjectStatusX.fromEnum(data.projectStatus),
            style: lv05TextStyle.copyWith(color: Colors.grey),
          ),
          Text(data.projectCreatedBy, style: lv05TextStyle),
          const SizedBox(height: 4),
          Text(
            HelperDateConvert.toDisplayUI(date: data.projectStart),
            style: lv05TextStyle,
          ),
          const SizedBox(height: 4),
          Text(
            HelperDateConvert.toDisplayUI(date: data.projectEnd),
            style: lv05TextStyle,
          ),
          const SizedBox(height: 4),
          Text(data.projectTotalContribut.toString(), style: lv05TextStyle),
          const SizedBox(height: 4),
        ],
        onPressed: (data) => {},
      ),
    );
  }
}
