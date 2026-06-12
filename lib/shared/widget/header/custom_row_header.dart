import 'package:flutter/material.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/page/notification_widget.dart';

class CustomRowHeader extends StatelessWidget {
  final Widget widgetLeft;
  final Widget widgetRight;
  const CustomRowHeader({
    super.key,
    required this.widgetLeft,
    required this.widgetRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: widgetLeft),
        Expanded(child: widgetRight),
        NotificationWidget(),
      ],
    );
  }
}
