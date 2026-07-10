// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_event.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_comment.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/style/text_size.dart';

class TaskDetailComment extends StatefulWidget {
  final ScrollController scrollController;
  const TaskDetailComment({super.key, required this.scrollController});

  @override
  State<TaskDetailComment> createState() => _TaskDetailCommentState();
}

class _TaskDetailCommentState extends State<TaskDetailComment> {
  final contentController = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  @override
  void dispose() {
    contentController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Comments", style: titleTextStyle),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: TaskDetailListComment(
            scrollController: widget.scrollController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
            top: 5,
          ),
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: keyForm,
                  child: CustomTextField(
                    controller: contentController,
                    hint: true,
                    label: "Type comment",
                    validator: (value) =>
                        value!.isEmpty ? "Type something first!" : null,
                  ),
                ),
              ),
              CustomButton(
                backgroundColor: AppPropertyColor.primary,
                child: Icon(Icons.send_rounded, color: AppPropertyColor.white),
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
        ),
      ],
    );
  }
}
