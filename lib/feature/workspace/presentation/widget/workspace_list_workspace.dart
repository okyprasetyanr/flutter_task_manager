import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_workspace.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/listview/custom_list_view_builder_v.dart';

class WorkspaceListWorkspace extends StatelessWidget {
  const WorkspaceListWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WorkspaceBloc,
      WorkspaceState,
      (List<ModelWorkspace>, EnumStatusState)
    >(
      selector: (state) => state is WorkspaceStateLoaded
          ? (state.dataWorkspace, state.status)
          : (const [], EnumStatusState.loading),
      builder: (context, state) {
        return CustomListViewBuilderV<ModelWorkspace>(
          content: (data, _) => [
            Text(data.name, style: lv05TextStyle),
            const SizedBox(height: 4),
            Text(
              data.description,
              style: lv05TextStyle.copyWith(color: Colors.grey),
            ),
          ],
          data: state.$1,
          status: state.$2,
          onPressed: (data) => RoutesNavigator(
            context: context,
            routeName: RoutesEnum.workspaceDetail,
            replace: false,
            arguments: {'dataTransfered': data},
          ).navigate(),
        );
      },
    );
  }
}
