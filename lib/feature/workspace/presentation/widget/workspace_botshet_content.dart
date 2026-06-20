import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';

class WorkspaceBotshetContent extends StatefulWidget {
  final ScrollController scrollController;
  const WorkspaceBotshetContent({super.key, required this.scrollController});

  @override
  State<WorkspaceBotshetContent> createState() =>
      _WorkspaceBotshetContentState();
}

class _WorkspaceBotshetContentState extends State<WorkspaceBotshetContent> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceBloc, WorkspaceState>(
      listenWhen: (previous, current) =>
          previous is WorkspaceStateLoaded &&
          current is WorkspaceStateLoaded &&
          previous.status == EnumStatusState.synchronize &&
          current.status == EnumStatusState.none,
      listener: (context, state) {
        Navigator.pop(context);
      },
      child: BlocSelector<WorkspaceBloc, WorkspaceState, ModelWorkspaceMerge?>(
        selector: (state) =>
            state is WorkspaceStateLoaded ? state.selectedWorkspace : null,
        builder: (context, data) {
          if (data != null) {
            nameController.text = data.dataWorkspace.name;
            descriptionController.text = data.dataWorkspace.description;
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Form Workspace", style: titleTextStyle),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _keyForm,
                      child: ListView(
                        controller: widget.scrollController,
                        children: [
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: nameController,
                            label: "Name",
                            validator: (value) =>
                                value!.isEmpty ? "Name required!" : null,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: descriptionController,
                            label: "Description",
                            validator: (value) =>
                                value!.isEmpty ? "Description required!" : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                BlocSelector<WorkspaceBloc, WorkspaceState, EnumStatusState>(
                  selector: (state) => state is WorkspaceStateLoaded
                      ? state.status
                      : EnumStatusState.none,
                  builder: (context, state) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: state == EnumStatusState.synchronize
                        ? CustomLoading()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (data != null)
                                Expanded(
                                  child: CustomButtonIcon(
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: AppPropertyColor.white,
                                    ),
                                    backgroundColor: AppPropertyColor.red,
                                    label: Text(
                                      "Delete",
                                      style: lv1TextStyleWhite,
                                    ),
                                    padding: true,
                                    onPressed: () => context
                                        .read<WorkspaceBloc>()
                                        .add(WorkspaceEventDeleteWorkspace()),
                                  ),
                                ),
                              Expanded(
                                child: CustomButtonIcon(
                                  icon: Icon(
                                    Icons.check_rounded,
                                    color: AppPropertyColor.white,
                                  ),
                                  backgroundColor: AppPropertyColor.primary,
                                  label: Text(
                                    data != null ? "Update" : "Add",
                                    style: lv1TextStyleWhite,
                                  ),
                                  padding: true,
                                  onPressed: () {
                                    if (!_keyForm.currentState!.validate()) {
                                      return;
                                    }
                                    data != null
                                        ? context.read<WorkspaceBloc>().add(
                                            WorkspaceEventUpdateWorkspace(
                                              name: nameController.text,
                                              description:
                                                  descriptionController.text,
                                              contributor: {},
                                            ),
                                          )
                                        : context.read<WorkspaceBloc>().add(
                                            WorkspaceEventCreateWorkspace(
                                              name: nameController.text,
                                              description:
                                                  descriptionController.text,
                                              contributor: {},
                                            ),
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
