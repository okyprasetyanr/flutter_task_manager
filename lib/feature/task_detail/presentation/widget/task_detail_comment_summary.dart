import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/task_detail/presentation/bloc/task_detail_bloc.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_comment.dart';
import 'package:task_manager/feature/task_detail/presentation/widget/task_detail_list_comment.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/style/text_size.dart';

class TaskDetailCommentSummary extends StatelessWidget {
  const TaskDetailCommentSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Comment Summary", style: lv1TextStyleBold),
        const SizedBox(height: 5),
        Material(
          color: AppPropertyColor.white,
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: Column(
            children: [
              TaskDetailListComment(limit: 2),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => customBottomSheet(
                    context: context,
                    resetItemForm: () {},
                    content: (scrollController) {
                      return BlocProvider.value(
                        value: context.read<TaskDetailBloc>(),
                        child: TaskDetailComment(
                          scrollController: scrollController,
                        ),
                      );
                    },
                  ),
                  child: Material(
                    color: AppPropertyColor.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Show All Comment",
                        style: lv1TextStyleWhite,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
