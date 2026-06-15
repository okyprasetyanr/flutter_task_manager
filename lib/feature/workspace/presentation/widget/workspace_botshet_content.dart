import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/widget/loading/custom_loading.dart';
import 'package:task_manager/shared/widget/text_field/custom_text_field.dart';

class WorkspaceBotshetContent extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> keyForm;
  final ScrollController scrollController;
  final bool update;
  final dynamic Function({required String name, required String description})
  onPressed;
  final dynamic Function()? onDelete;
  const WorkspaceBotshetContent({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.keyForm,
    required this.scrollController,
    required this.onPressed,
    required this.update,
    this.onDelete,
  });

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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Form Create Workspace", style: titleTextStyle),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: keyForm,
                  child: ListView(
                    controller: scrollController,
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
                          if (onDelete != null)
                            Expanded(
                              child: CustomButtonIcon(
                                icon: Icon(
                                  Icons.delete_rounded,
                                  color: AppPropertyColor.white,
                                ),
                                backgroundColor: AppPropertyColor.red,
                                label: Text("Delete", style: lv1TextStyleWhite),
                                padding: true,
                                onPressed: () {
                                  onDelete!();
                                },
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
                                update ? "Update" : "Add",
                                style: lv1TextStyleWhite,
                              ),
                              padding: true,
                              onPressed: () {
                                if (!keyForm.currentState!.validate()) {
                                  return;
                                }
                                onPressed(
                                  name: nameController.text,
                                  description: descriptionController.text,
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
      ),
    );
  }
}
