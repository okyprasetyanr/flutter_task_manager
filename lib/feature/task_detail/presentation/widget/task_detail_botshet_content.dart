import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_state.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/icon_size.dart';
import 'package:task_manager/shared/style/text_size.dart';

class TaskDetailBotshetContent extends StatefulWidget {
  const TaskDetailBotshetContent({super.key});

  @override
  State<TaskDetailBotshetContent> createState() =>
      _TaskDetailBotshetContentState();
}

class _TaskDetailBotshetContentState extends State<TaskDetailBotshetContent> {
  final titleController = TextEditingController();
  final isDone = ValueNotifier<bool>(false);
  final _keyForm = GlobalKey<FormState>();
  @override
  void dispose() {
    titleController.dispose();
    isDone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskDetailBloc, TaskDetailState>(
      listenWhen: (previous, current) =>
          previous is TaskDetailStateLoaded &&
          current is TaskDetailStateLoaded &&
          previous.status == EnumStatusState.synchronize &&
          current.status == EnumStatusState.none,
      listener: (context, state) => Navigator.pop(context),
      child:
          BlocSelector<
            TaskDetailBloc,
            TaskDetailState,
            (ModelSubTask?, EnumStatusState)
          >(
            selector: (state) => state is TaskDetailStateLoaded
                ? (state.selectedSubtask, state.status)
                : (null, EnumStatusState.none),
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("SubTask Form", style: titleTextStyle),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _keyForm,
                            child: CustomTextField(
                              label: "Title",
                              validator: (value) =>
                                  value!.isEmpty ? "Title is required" : null,
                              controller: titleController,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ValueListenableBuilder(
                          valueListenable: isDone,
                          builder: (context, value, child) => GestureDetector(
                            onTap: () => isDone.value = !isDone.value,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: 100,
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              height: 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: value
                                    ? AppPropertyColor.primary
                                    : AppPropertyColor.white,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (value
                                                ? AppPropertyColor.black
                                                : AppPropertyColor.primary)
                                            .withValues(alpha: 0.6),
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    curve: Curves.easeInOut,
                                    left: value ? -50 : 5,
                                    top: 1,
                                    duration: Duration(milliseconds: 500),
                                    child: Icon(
                                      Icons.radio_button_unchecked_rounded,
                                      size: lv2IconSize,
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    curve: Curves.easeInOut,
                                    left: value ? 75 : 150,
                                    top: 1,
                                    duration: Duration(milliseconds: 500),
                                    child: Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: lv2IconSize,
                                      color: AppPropertyColor.white,
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    curve: Curves.easeInOut,
                                    top: 4,
                                    left: value ? -100 : 33,
                                    duration: Duration(milliseconds: 500),
                                    child: Text(
                                      "Todo",
                                      style: lv1TextStyleBold,
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    curve: Curves.easeInOut,
                                    left: value ? 10 : 150,
                                    top: 4,
                                    duration: Duration(milliseconds: 500),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Done",
                                        style: lv1TextStyleWhiteBold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    BlocSelector<
                      TaskDetailBloc,
                      TaskDetailState,
                      EnumStatusState
                    >(
                      selector: (state) => state is TaskDetailStateLoaded
                          ? state.status
                          : EnumStatusState.none,
                      builder: (context, status) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: status == EnumStatusState.synchronize
                            ? const CustomLoading()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (state.$1 != null)
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
                                            context.read<TaskDetailBloc>().add(
                                              TaskDetailEventDeleteSubtask(),
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
                                        state.$1 == null ? "Add" : "Update",
                                        style: lv1TextStyleWhite,
                                      ),
                                      onPressed: () {
                                        if (!_keyForm.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        state.$1 != null
                                            ? context.read<TaskDetailBloc>().add(
                                                TaskDetailEventUpdateSubtask(
                                                  isDone: isDone.value,
                                                  title: titleController.text,
                                                ),
                                              )
                                            : context.read<TaskDetailBloc>().add(
                                                TaskDetailEventCreateSubtask(
                                                  title: titleController.text,
                                                  isDone: isDone.value,
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
