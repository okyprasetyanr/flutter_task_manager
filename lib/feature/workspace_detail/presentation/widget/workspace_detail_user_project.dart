import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_botshet_user_project.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading_linear.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WorkspaceDetailUserProject extends StatelessWidget {
  const WorkspaceDetailUserProject({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WorkspaceDetailBloc,
      WorkspaceDetailState,
      (ModelUser?, Set<ModelProjectMerge>)
    >(
      selector: (state) => state is WorkspaceDetailStateLoaded
          ? (state.dataAccount, state.userAssignedProject)
          : (null, {}),
      builder: (context, state) {
        state.$2.toList().sort(
          (a, b) => a.dataProject.end.compareTo(b.dataProject.end),
        );
        return state.$1 == null
            ? CustomLoadingLinear()
            : state.$2.isEmpty
            ? CustomTextEmpty(
                text: "You are not Assigned to any Project in this Workspace",
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${state.$1!.name}, You were Assigned to ${state.$2.length} Project, and",
                        style: lv1TextStyle,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: state.$2.first.dataProject.name,
                              style: lv05TextStyleBold,
                            ),
                            TextSpan(
                              text: " has the closest deadline!",
                              style: lv05TextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    backgroundColor: AppPropertyColor.primary,
                    padding: false,
                    child: Icon(
                      Icons.visibility,
                      color: AppPropertyColor.white,
                    ),
                    onPressed: () {
                      final bloc = context.read<WorkspaceDetailBloc>();
                      customBottomSheet(
                        context: context,
                        resetItemForm: null,
                        content: (scrollController) {
                          return BlocProvider.value(
                            value: bloc,
                            child: WorkspaceDetailBotshetUserProject(
                              scrollController: scrollController,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
      },
    );
  }
}
