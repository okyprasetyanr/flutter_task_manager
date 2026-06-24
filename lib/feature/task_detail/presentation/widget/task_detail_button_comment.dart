// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_comment.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';

class TaskDetailButtonComment extends StatefulWidget {
  const TaskDetailButtonComment({super.key});

  @override
  State<TaskDetailButtonComment> createState() =>
      _TaskDetailButtonCommentState();
}

class _TaskDetailButtonCommentState extends State<TaskDetailButtonComment> {
  final contentController = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  @override
  void dispose() {
    contentController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CustomButtonIcon(
        icon: Icon(Icons.comment_rounded, color: AppPropertyColor.white),
        backgroundColor: AppPropertyColor.primary,
        label: Text("Comments", style: lv05TextStyleWhite),
        onPressed: () {
          final bloc = context.read<TaskDetailBloc>();
          customBottomSheet(
            context: context,
            resetItemForm: () => contentController.clear(),
            content: (scrollController) {
              return BlocProvider.value(
                value: bloc,
                child: Column(
                  children: [
                    Expanded(
                      child: TaskDetailListComment(
                        scrollController: scrollController,
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: keyForm,
                            child: CustomTextField(
                              controller: contentController,
                              hint: true,
                              label: "Type comment",
                              validator: (value) => value!.isEmpty
                                  ? "Type something first!"
                                  : null,
                            ),
                          ),
                        ),
                        CustomButton(
                          backgroundColor: AppPropertyColor.primary,
                          child: Icon(
                            Icons.send_rounded,
                            color: AppPropertyColor.white,
                          ),
                          onPressed: () {
                            if (!keyForm.currentState!.validate()) {
                              return;
                            }
                            context.read<TaskDetailBloc>().add(
                              TaskDetailEventCreateComment(
                                content: contentController.text,
                              ),
                            );
                            contentController.clear();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
