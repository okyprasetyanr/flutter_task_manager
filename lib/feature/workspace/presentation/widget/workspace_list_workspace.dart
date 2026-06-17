import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/shared_component/widget/member_list/widget_member_list.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_botshet_content.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

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
    return BlocListener<WorkspaceBloc, WorkspaceState>(
      listenWhen: (previous, current) =>
          previous is WorkspaceStateLoaded &&
          current is WorkspaceStateLoaded &&
          previous.initMember == null &&
          current.initMember == true,
      listener: (context, state) {
        if (state is WorkspaceStateLoaded) {
          context.read<WorkspaceBloc>().add(WorkspaceEventWatchMember());
        }
      },
      child:
          BlocSelector<
            WorkspaceBloc,
            WorkspaceState,
            (Set<ModelWorkspaceMerge>, EnumStatusState)
          >(
            selector: (state) => state is WorkspaceStateLoaded
                ? (state.dataWorkspace, state.status)
                : (const {}, EnumStatusState.loading),
            builder: (context, state) {
              return CustomListViewBuilderV<ModelWorkspaceMerge>(
                data: state.$1.toList(),
                status: state.$2,
                content: (data, status) => [
                  Text(data.dataWorkspace.name, style: lv05TextStyle),
                  const SizedBox(height: 4),
                  Text(
                    data.dataWorkspace.description,
                    style: lv05TextStyle.copyWith(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                    child:
                        data.dataWorkspaceMember.isEmpty &&
                            status == EnumStatusState.synchronize
                        ? const CustomLoading()
                        : data.dataWorkspaceMember.isEmpty &&
                              status == EnumStatusState.none
                        ? const CustomTextEmpty()
                        : SharedWidgetMemberList(
                            data: data.dataWorkspaceMember,
                            status: status,
                          ),
                  ),
                ],
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
                      nameController.text = data.dataWorkspace.name;
                      descriptionController.text =
                          data.dataWorkspace.description;
                      return BlocProvider.value(
                        value: bloc,
                        child: WorkspaceBotshetContent(
                          nameController: nameController,
                          descriptionController: descriptionController,
                          keyForm: keyForm,
                          scrollController: scrollController,
                          update: true,
                          onPressed: ({required description, required name}) =>
                              {
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
          ),
    );
  }
}
