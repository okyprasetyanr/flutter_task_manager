import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
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
      allowScroll: false,
      changeColor: AppPropertyColor.primary,
      smallSpace: true,
      dataName: "Subtask",
      limit: 3,
      status: status,
      data: data.toList(),
      content: (data, _) => [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.title, style: lv05TextStyleWhite),
                Material(
                  color: AppPropertyColor.white,
                  borderRadius: BorderRadius.circular(8),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      data.isDone ? "Done" : "On Progress",
                      style: lv05TextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
