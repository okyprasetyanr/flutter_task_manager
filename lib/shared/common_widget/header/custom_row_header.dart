import 'package:flutter/material.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/page/not_log_widget.dart';

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
        widgetRight,
        const SizedBox(width: 10),
        NotLogWidget(),
      ],
    );
  }
}
