import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

class ProjectDetailProject extends StatelessWidget {
  const ProjectDetailProject({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ProjectDetailBloc,
      ProjectDetailState,
      (ModelProject?, EnumStatusState)
    >(
      selector: (state) => state is ProjectDetailStateLoaded
          ? (state.dataProject, state.status)
          : (null, EnumStatusState.loading),
      builder: (context, state) {
        if (state.$1 == null && state.$2 == EnumStatusState.loading) {
          return CustomLoading();
        } else if (state.$1 == null && state.$2 != EnumStatusState.loading) {
          return CustomTextEmpty();
        }
        final data = state.$1!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.name, style: lv05TextStyle),
                Text(data.type, style: lv05TextStyle),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.status.text,
                  style: lv05TextStyle.copyWith(color: Colors.grey),
                ),
                Text(data.createdBy, style: lv05TextStyle),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  HelperDateConvert.toDisplayUI(date: data.start),
                  style: lv05TextStyle,
                ),
                Text(
                  HelperDateConvert.toDisplayUI(date: data.end),
                  style: lv05TextStyle,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(data.totalContribut.toString(), style: lv05TextStyle),
            const SizedBox(height: 4),
          ],
        );
      },
    );
  }
}
