import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/widget/drop_down/widget_drop_down.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
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
  bool _initialized = false;

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
    return BlocListener<WorkspaceDetailBloc, WorkspaceDetailState>(
      listenWhen: (previous, current) =>
          previous is WorkspaceDetailStateLoaded &&
          current is WorkspaceDetailStateLoaded &&
          previous.status == EnumStatusState.synchronize &&
          current.status == EnumStatusState.none,
      listener: (context, state) {
        Navigator.pop(context);
      },
      child: BlocSelector<WorkspaceDetailBloc, WorkspaceDetailState, ModelProjectMerge?>(
        selector: (state) {
          if (state is WorkspaceDetailStateLoaded) {
            return state.selectedProject;
          }
          return null;
        },
        builder: (context, data) {
          if (!_initialized && data != null) {
            _initialized = true;
            nameController.text = data.dataProject.name;
            typeController.text = data.dataProject.type;
            projectStatus.value = data.dataProject.status;
            pickedStart.value = data.dataProject.start;
            pickedEnd.value = data.dataProject.end;
            createdAt = data.dataProject.createdAt;
            devLog(
              "Log WorkspaceDetailBotShetContent: data: ${data.dataProject.status}",
            );
          }

          return Column(
            children: [
              Form(
                key: _keyForm,
                child: Column(
                  children: [
                    CustomTextField(
                      label: "Name",
                      controller: nameController,
                      enable: data == null,
                      validator: (value) =>
                          value!.isEmpty ? "Project Name required!" : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "Type",
                            controller: typeController,
                            validator: (value) =>
                                value!.isEmpty ? "Type required!" : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ValueListenableBuilder<EnumProjectStatus>(
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: AppPropertyColor.white,
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
                            builder: (context, value, child) => Text(
                              HelperDateConvert.toDisplayUI(date: value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: AppPropertyColor.white,
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
                            builder: (context, value, child) => Text(
                              HelperDateConvert.toDisplayUI(date: value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              BlocSelector<
                WorkspaceDetailBloc,
                WorkspaceDetailState,
                EnumStatusState
              >(
                selector: (state) => state is WorkspaceDetailStateLoaded
                    ? state.status
                    : EnumStatusState.none,
                builder: (context, status) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: status == EnumStatusState.synchronize
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
                                      .read<WorkspaceDetailBloc>()
                                      .add(WorkspaceDetailEventDeleteProject()),
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
                                  data == null ? "Add" : "Update",
                                  style: lv1TextStyleWhite,
                                ),
                                onPressed: () {
                                  if (!_keyForm.currentState!.validate()) {
                                    return;
                                  }
                                  if (pickedStart.value.isAfter(
                                    pickedEnd.value,
                                  )) {
                                    return customSnackBar(
                                      context,
                                      "The start date cannot be after the end date!",
                                    );
                                  }
                                  data != null
                                      ? context.read<WorkspaceDetailBloc>().add(
                                          WorkspaceDetailEventUpdateProject(
                                            start: pickedStart.value,
                                            end: pickedEnd.value,
                                            createdAt: createdAt,
                                            contributor: {},
                                            type: typeController.text,
                                            status: projectStatus.value,
                                          ),
                                        )
                                      : context.read<WorkspaceDetailBloc>().add(
                                          WorkspaceDetailEventCreateProject(
                                            name: nameController.text,
                                            start: pickedStart.value,
                                            end: pickedEnd.value,
                                            createdAt: createdAt,
                                            contributor: {},
                                            type: typeController.text,
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
          );
        },
      ),
    );
  }
}
