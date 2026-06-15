import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_botshet_content.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/listview/custom_list_view_builder_v.dart';

class WorkspaceListWorkspace extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> keyForm;
  const WorkspaceListWorkspace({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.keyForm,
  });

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
          onEdit: (data) {
            context.read<WorkspaceBloc>().add(
              WorkspaceEventSelectedData(data: data),
            );
            return customBottomSheet(
              context: context,
              resetItemForm: () {
                nameController.clear();
                descriptionController.clear();
              },
              content: (scrollController) {
                final bloc = context.read<WorkspaceBloc>();
                nameController.text = data.name;
                descriptionController.text = data.description;
                return BlocProvider.value(
                  value: bloc,
                  child: WorkspaceBotshetContent(
                    nameController: nameController,
                    descriptionController: descriptionController,
                    keyForm: keyForm,
                    scrollController: scrollController,
                    update: true,
                    onPressed: ({required description, required name}) => {
                      context.read<WorkspaceBloc>().add(
                        WorkspaceEventUpdateWorkspace(
                          name: name,
                          description: description,
                        ),
                      ),
                    },
                    onDelete: () => context.read<WorkspaceBloc>().add(
                      WorkspaceEventDeleteWorkspace(),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
