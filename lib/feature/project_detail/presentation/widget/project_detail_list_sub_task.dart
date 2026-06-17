import 'package:flutter/material.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class ProjectDetailListSubTask extends StatelessWidget {
  final Set<ModelSubTask> data;
  final EnumStatusState status;
  const ProjectDetailListSubTask({
    super.key,
    required this.data,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListViewBuilderV<ModelSubTask>(
      limit: 3,
      status: status,
      data: data.toList(),
      content: (data, _) => [
        Card(
          elevation: 2,
          color: AppPropertyColor.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.title, style: lv05TextStyle),
                    Text(
                      data.isDone ? "Done" : "On Progress",
                      style: lv05TextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
