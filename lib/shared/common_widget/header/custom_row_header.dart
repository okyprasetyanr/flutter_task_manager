import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/page/not_log_widget.dart';

class CustomRowHeader extends StatelessWidget {
  final Widget widgetLeft;
  final Widget widgetRight;
  final bool logoutIcon;
  final Color? color;
  const CustomRowHeader({
    super.key,
    required this.widgetLeft,
    required this.widgetRight,
    this.logoutIcon = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppPropertyColor.primary,
      elevation: 3,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          children: [
            Expanded(child: widgetLeft),
            widgetRight,
            const SizedBox(width: 10),
            NotLogWidget(logoutIcon: logoutIcon),
          ],
        ),
      ),
    );
  }
}
