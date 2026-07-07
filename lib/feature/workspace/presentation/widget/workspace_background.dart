import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';

class WorkspaceBackground extends StatelessWidget {
  const WorkspaceBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppPropertyColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
    );
  }
}
