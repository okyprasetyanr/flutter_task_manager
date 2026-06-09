import 'package:flutter/material.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/style/text_size.dart';

class ProjectDetailListSubTask extends StatelessWidget {
  final List<ModelSubTask> data;
  const ProjectDetailListSubTask({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...data.map((e) {
          return Card(
            elevation: 2,
            color: AppPropertyColor.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.title, style: lv05TextStyle),
                      Text(
                        e.isDone ? "Done" : "On Progress",
                        style: lv05TextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
