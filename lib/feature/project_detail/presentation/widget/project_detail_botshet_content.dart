import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_label.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/widget/drop_down/widget_drop_down.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/date_picker/custom_date_picker.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/style/icon_size.dart';
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
  final searchController = TextEditingController();
  final pickedStart = ValueNotifier<DateTime>(DateTime.now());
  final pickedEnd = ValueNotifier<DateTime>(DateTime.now());
  final taskStatus = ValueNotifier<EnumTaskStatus>(EnumTaskStatus.todo);
  final taskPriority = ValueNotifier<EnumTaskPriority>(EnumTaskPriority.lowest);
  final _keyForm = GlobalKey<FormState>();
  final listLabel = <ModelLabel>{}.obs;
  String? assigneeId;
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
      child: BlocSelector<ProjectDetailBloc, ProjectDetailState, (ModelTaskMerge?, Set<ModelLabel>)>(
        selector: (state) {
          if (state is ProjectDetailStateLoaded) {
            return (state.selectedTask, state.dataLabel);
          }
          return (null, const {});
        },
        builder: (context, data) {
          if (!_initialized && data.$1 != null) {
            _initialized = true;
            titleController.text = data.$1!.dataTask.title;
            descriptionController.text = data.$1!.dataTask.description;
            pickedStart.value = data.$1!.dataTask.startDate;
            pickedEnd.value = data.$1!.dataTask.dueDate;
            taskPriority.value = data.$1!.dataTask.priority;
            taskStatus.value = data.$1!.dataTask.status;
            storyPointController.text = data.$1!.dataTask.storyPoint.toString();
            final idLabel = data.$1!.dataTaskLabel.map((e) => e.id).toSet();
            final finalTaskLabel = data.$2
                .where((element) => idLabel.contains(element.id))
                .toSet();
            listLabel.addAll(finalTaskLabel);
            assigneeId = data.$1!.dataTask.assigneeId;
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
                        enable: data.$1 == null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: descriptionController,
                        label: "Description",
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              validator: (value) => value!.isEmpty
                                  ? "Story Point is required"
                                  : null,
                              controller: storyPointController,
                              label: "Story Point",
                              inputType: TextInputType.number,
                              prefix: Icon(Icons.bar_chart_rounded),
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child:
                                BlocSelector<
                                  ProjectDetailBloc,
                                  ProjectDetailState,
                                  Set<ModelUser>
                                >(
                                  selector: (state) =>
                                      state is ProjectDetailStateLoaded
                                      ? state.filteredUser
                                      : const {},
                                  builder: (context, state) =>
                                      Autocomplete<ModelUser>(
                                        displayStringForOption:
                                            (ModelUser option) => option.name,
                                        optionsBuilder:
                                            (
                                              TextEditingValue textEditingValue,
                                            ) {
                                              if (textEditingValue
                                                  .text
                                                  .isEmpty) {
                                                return <ModelUser>{};
                                              }
                                              return state.where(
                                                (option) => option.name
                                                    .toLowerCase()
                                                    .contains(
                                                      textEditingValue.text
                                                          .toLowerCase(),
                                                    ),
                                              );
                                            },
                                        onSelected: (option) =>
                                            assigneeId = option.id,
                                        fieldViewBuilder:
                                            (
                                              context,
                                              textEditingController,
                                              focusNode,
                                              onFieldSubmitted,
                                            ) {
                                              if (data.$1 != null) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                      final name = state
                                                          .firstWhere(
                                                            (element) =>
                                                                element.id ==
                                                                data
                                                                    .$1!
                                                                    .dataTask
                                                                    .assigneeId,
                                                          )
                                                          .name;

                                                      if (textEditingController
                                                              .text !=
                                                          name) {
                                                        textEditingController
                                                                .text =
                                                            name;
                                                      }
                                                    });
                                              }
                                              return CustomTextField(
                                                controller:
                                                    textEditingController,
                                                focusNode: focusNode,
                                                prefix: Icon(Icons.person),
                                                validator: (value) =>
                                                    value!.isEmpty
                                                    ? "Assignee is required!"
                                                    : null,
                                                label: "Assignee",
                                              );
                                            },
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

                const SizedBox(height: 5),
                const Divider(
                  thickness: 0.5,
                  color: AppPropertyColor.grey,
                  indent: 16,
                  endIndent: 16,
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("List Label", style: lv2TextStyle),
                            Expanded(
                              child: Obx(() {
                                return GridView.builder(
                                  itemCount: listLabel.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                        childAspectRatio: 3,
                                      ),
                                  itemBuilder: (context, index) {
                                    final data = listLabel.elementAt(index);
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        CustomButton(
                                          backgroundColor:
                                              AppPropertyColor.white,
                                          onPressed: () =>
                                              listLabel.removeWhere(
                                                (element) =>
                                                    element.id == data.id,
                                              ),
                                          child: Icon(
                                            Icons.close_rounded,
                                            color: AppPropertyColor.red,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                            BlocSelector<
                              ProjectDetailBloc,
                              ProjectDetailState,
                              Set<ModelLabel>
                            >(
                              selector: (state) =>
                                  state is ProjectDetailStateLoaded
                                  ? state.filteredLabel
                                  : {},
                              builder: (context, state) => Column(
                                children: [
                                  CustomTextField(
                                    controller: searchController,
                                    label: "Search new Label",
                                    onChanged: (value) =>
                                        context.read<ProjectDetailBloc>().add(
                                          ProjectDetailEventSearchLabel(
                                            search: value,
                                          ),
                                        ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: widget.scrollController,
                                      shrinkWrap: true,
                                      itemCount: state.length,
                                      itemBuilder: (context, index) {
                                        final data = state.elementAt(index);
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Obx(
                                              () => CustomButton(
                                                backgroundColor:
                                                    AppPropertyColor.white,
                                                onPressed: () =>
                                                    listLabel.any(
                                                      (element) =>
                                                          element.id == data.id,
                                                    )
                                                    ? customSnackBar(
                                                        context,
                                                        "${data.name} was added!",
                                                        top: true,
                                                      )
                                                    : listLabel.add(data),
                                                child:
                                                    listLabel.any(
                                                      (element) =>
                                                          element.id == data.id,
                                                    )
                                                    ? Icon(
                                                        Icons
                                                            .check_circle_outline_rounded,
                                                        size: lv2IconSize,
                                                        color: AppPropertyColor
                                                            .primary,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .radio_button_unchecked_rounded,
                                                        size: lv2IconSize,
                                                      ),
                                              ),
                                            ),
                                          ],
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
                              if (data.$1 != null)
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
                                            taskId: data.$1!.dataTask.id,
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
                                    data.$1 != null ? "Update" : "Add",
                                    style: lv1TextStyleWhite,
                                  ),
                                  padding: true,
                                  onPressed: () {
                                    if (!_keyForm.currentState!.validate()) {
                                      return;
                                    }
                                    data.$1 != null
                                        ? context.read<ProjectDetailBloc>().add(
                                            ProjectDetailEventUpdateTask(
                                              description:
                                                  descriptionController.text,
                                              storyPoint: int.tryParse(
                                                storyPointController.text,
                                              )!,
                                              assigneeId: assigneeId!,
                                              due: pickedEnd.value,
                                              start: pickedStart.value,
                                              priority: taskPriority.value,
                                              status: taskStatus.value,
                                              taskLabel: listLabel.toSet(),
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
                                              assigneeId: assigneeId!,
                                              due: pickedEnd.value,
                                              start: pickedStart.value,
                                              priority: taskPriority.value,
                                              status: taskStatus.value,
                                              taskLabel: listLabel.toSet(),
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
