import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/main_menu/data/models/model_project.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/helper/common_helper.dart';
import 'package:task_manager/shared/widget/loading/widget_loading.dart';
import 'package:task_manager/style/text_size.dart';

class UIProjectLayout extends StatelessWidget {
  const UIProjectLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: BlocSelector<ProjectDetailBloc, ProjectDetailState, ModelProject?>(
          selector: (state) =>
              state is ProjectDetailLoaded ? state.dataProject : null,
          builder: (context, state) {
            return state == null
                ? customLoading()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.projectName, style: lv05TextStyle),
                          Text(state.projectType, style: lv05TextStyle),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Start: ${formatDate(date: state.projectStart, minute: false)}",
                            style: lv05TextStyle,
                          ),
                          Text(
                            "End: ${formatDate(date: state.projectEnd, minute: false)}",
                            style: lv05TextStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.projectStatus, style: lv05TextStyle),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Created By: ",
                                  style: lv05TextStyle,
                                ),
                                TextSpan(
                                  text: state.projectCreatedBy,
                                  style: lv1TextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
