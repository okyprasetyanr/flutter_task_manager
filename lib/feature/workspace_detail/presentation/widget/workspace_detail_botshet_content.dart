import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/shared_component/widget/drop_down/widget_drop_down.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/date_picker/custom_date_picker.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WorkspaceDetailBotshetContent extends StatefulWidget {
  final ScrollController scrollController;
  const WorkspaceDetailBotshetContent({
    super.key,
    required this.scrollController,
  });

  @override
  State<WorkspaceDetailBotshetContent> createState() =>
      _WorkspaceDetailBotshetContentState();
}

class _WorkspaceDetailBotshetContentState
    extends State<WorkspaceDetailBotshetContent> {
  final pickedStart = ValueNotifier<DateTime>(DateTime.now());
  final pickedEnd = ValueNotifier<DateTime>(DateTime.now());
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  final projectStatus = ValueNotifier<EnumProjectStatus>(
    EnumProjectStatus.unknown,
  );

  DateTime createdAt = DateTime.now();
  @override
  void dispose() {
    pickedStart.dispose();
    pickedEnd.dispose();
    nameController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WorkspaceDetailBloc,
      WorkspaceDetailState,
      ModelProjectMerge?
    >(
      selector: (state) {
        if (state is WorkspaceDetailStateLoaded) {
          return state.selectedProject;
        }
        return null;
      },
      builder: (context, state) {
        if (state != null) {
          nameController.text = state.dataProject.name;
          typeController.text = state.dataProject.type;
          projectStatus.value = state.dataProject.status;
          pickedStart.value = state.dataProject.start;
          pickedEnd.value = state.dataProject.end;
          createdAt = state.dataProject.createdAt;
          devLog(
            "Log WorkspaceDetailBotShetContent: data: ${state.dataProject.status}",
          );
        }

        return SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            children: [
              Form(
                key: _keyForm,
                child: Column(
                  children: [
                    CustomTextField(
                      label: "Name",
                      controller: nameController,
                      enable: state == null,
                      validator: (value) =>
                          value!.isEmpty ? "Project Name required!" : null,
                    ),

                    CustomTextField(
                      label: "Type",
                      controller: typeController,
                      validator: (value) =>
                          value!.isEmpty ? "Type required!" : null,
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder<EnumProjectStatus>(
                valueListenable: projectStatus,
                builder: (context, value, child) =>
                    WidgetDropDown<EnumProjectStatus>(
                      extension: (extension) => extension.text,
                      initialValue: value,
                      filters: EnumProjectStatus.values,
                      text: "Status",
                      selectedValue: (selectedEnum) =>
                          projectStatus.value = selectedEnum,
                    ),
              ),
              CustomButton(
                onPressed: () async => await customDatePicker(
                  dateEnd: false,
                  text: "Date Start",
                  context: context,
                  selectedDate: pickedStart.value,
                  picked: (picked) => pickedStart.value = picked,
                ),
                child: Column(
                  children: [
                    Text("Start", style: lv05TextStyle),
                    ValueListenableBuilder(
                      valueListenable: pickedStart,
                      builder: (context, value, child) =>
                          Text(HelperDateConvert.toDisplayUI(date: value)),
                    ),
                  ],
                ),
              ),
              CustomButton(
                onPressed: () async => await customDatePicker(
                  dateEnd: true,
                  text: "Date End",
                  context: context,
                  selectedDate: pickedEnd.value,
                  picked: (picked) => pickedEnd.value = picked,
                ),
                child: Column(
                  children: [
                    Text("End", style: lv05TextStyle),
                    ValueListenableBuilder(
                      valueListenable: pickedEnd,
                      builder: (context, value, child) =>
                          Text(HelperDateConvert.toDisplayUI(date: value)),
                    ),
                  ],
                ),
              ),
              CustomButton(
                onPressed: () {
                  if (!_keyForm.currentState!.validate()) {
                    return;
                  }
                  if (pickedStart.value.isAfter(pickedEnd.value)) {
                    return customSnackBar(
                      context,
                      "The start date cannot be after the end date!",
                    );
                  }
                  context.read<WorkspaceDetailBloc>().add(
                    WorkspaceDetailEventUpdateProject(
                      name: nameController.text,
                      start: pickedStart.value,
                      end: pickedEnd.value,
                      createdAt: createdAt,
                      contributor: {},
                      type: typeController.text,
                      status: projectStatus.value,
                    ),
                  );
                },
                child: Text(state == null ? "Add" : "Update"),
              ),
            ],
          ),
        );
      },
    );
  }
}
