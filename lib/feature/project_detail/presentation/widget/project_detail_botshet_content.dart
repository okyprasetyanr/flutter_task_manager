import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/feature/shared_component/widget/drop_down/widget_drop_down.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/date_picker/custom_date_picker.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/style/text_size.dart';

class ProjectDetailBotshetContent extends StatefulWidget {
  final ScrollController scrollController;
  const ProjectDetailBotshetContent({
    super.key,
    required this.scrollController,
  });

  @override
  State<ProjectDetailBotshetContent> createState() =>
      _ProjectDetailBotshetContentState();
}

class _ProjectDetailBotshetContentState
    extends State<ProjectDetailBotshetContent> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final storyPointController = TextEditingController();
  final pickedStart = ValueNotifier<DateTime>(DateTime.now());
  final pickedEnd = ValueNotifier<DateTime>(DateTime.now());
  final taskStatus = ValueNotifier<EnumTaskStatus>(EnumTaskStatus.todo);
  final taskPriority = ValueNotifier<EnumTaskPriority>(EnumTaskPriority.lowest);
  final _keyForm = GlobalKey<FormState>();
  bool _initialized = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    pickedStart.dispose();
    pickedEnd.dispose();
    storyPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectDetailBloc, ProjectDetailState>(
      listenWhen: (previous, current) =>
          previous is ProjectDetailStateLoaded &&
          current is ProjectDetailStateLoaded &&
          previous.status == EnumStatusState.synchronize &&
          current.status == EnumStatusState.none,
      listener: (context, state) {
        Navigator.pop(context);
      },
      child: BlocSelector<ProjectDetailBloc, ProjectDetailState, ModelTaskMerge?>(
        selector: (state) {
          if (state is ProjectDetailStateLoaded) {
            return state.selectedTask;
          }
          return null;
        },
        builder: (context, data) {
          if (!_initialized && data != null) {
            _initialized = true;
            titleController.text = data.dataTask.title;
            descriptionController.text = data.dataTask.description;
            pickedStart.value = data.dataTask.startDate;
            pickedEnd.value = data.dataTask.dueDate;
            taskPriority.value = data.dataTask.priority;
            taskStatus.value = data.dataTask.status;
            storyPointController.text = data.dataTask.storyPoint.toString();
            devLog("Log WorkspaceDetailBotShetContent: data: $data");
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task Form", style: titleTextStyle),
                const SizedBox(height: 10),
                Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      CustomTextField(
                        validator: (value) =>
                            value!.isEmpty ? "Title is required" : null,
                        controller: titleController,
                        label: "Title",
                        enable: data == null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: descriptionController,
                        label: "Description",
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        validator: (value) =>
                            value!.isEmpty ? "Story Point is required" : null,
                        controller: storyPointController,
                        label: "Story Point",
                        inputType: TextInputType.number,
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
                                style: lv1TextStyleBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
                        backgroundColor: AppPropertyColor.red,
                        onPressed: () async => await customDatePicker(
                          dateEnd: true,
                          text: "Date End",
                          context: context,
                          selectedDate: pickedEnd.value,
                          picked: (picked) => pickedEnd.value = picked,
                        ),
                        child: Column(
                          children: [
                            Text("End", style: lv05TextStyleWhite),
                            ValueListenableBuilder(
                              valueListenable: pickedEnd,
                              builder: (context, value, child) => Text(
                                HelperDateConvert.toDisplayUI(date: value),
                                style: lv1TextStyleWhiteBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<EnumTaskStatus>(
                        valueListenable: taskStatus,
                        builder: (context, value, child) =>
                            WidgetDropDown<EnumTaskStatus>(
                              extension: (extension) => extension.text,
                              initialValue: value,
                              filters: EnumTaskStatus.values,
                              text: "Status",
                              selectedValue: (selectedEnum) =>
                                  taskStatus.value = selectedEnum,
                            ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ValueListenableBuilder<EnumTaskPriority>(
                        valueListenable: taskPriority,
                        builder: (context, value, child) =>
                            WidgetDropDown<EnumTaskPriority>(
                              extension: (extension) => extension.text,
                              initialValue: value,
                              filters: EnumTaskPriority.values,
                              text: "Priority",
                              selectedValue: (selectedEnum) =>
                                  taskPriority.value = selectedEnum,
                            ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                BlocSelector<
                  ProjectDetailBloc,
                  ProjectDetailState,
                  EnumStatusState
                >(
                  selector: (state) => state is ProjectDetailStateLoaded
                      ? state.status
                      : EnumStatusState.none,
                  builder: (context, state) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: state == EnumStatusState.synchronize
                        ? const CustomLoading()
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
                                    onPressed: () =>
                                        context.read<ProjectDetailBloc>().add(
                                          ProjectDetailEventDeleteTask(
                                            taskId: data.dataTask.id,
                                          ),
                                        ),
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
                                        ? context.read<ProjectDetailBloc>().add(
                                            ProjectDetailEventUpdateTask(
                                              description:
                                                  descriptionController.text,
                                              storyPoint: int.tryParse(
                                                storyPointController.text,
                                              )!,
                                              assigneeId: "",
                                              due: pickedEnd.value,
                                              start: pickedStart.value,
                                              priority: taskPriority.value,
                                              status: taskStatus.value,
                                            ),
                                          )
                                        : context.read<ProjectDetailBloc>().add(
                                            ProjectDetailEventCreateTask(
                                              title: titleController.text,
                                              description:
                                                  descriptionController.text,
                                              storyPoint: int.tryParse(
                                                storyPointController.text,
                                              )!,
                                              assigneeId: "",
                                              due: pickedEnd.value,
                                              start: pickedStart.value,
                                              priority: taskPriority.value,
                                              status: taskStatus.value,
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
