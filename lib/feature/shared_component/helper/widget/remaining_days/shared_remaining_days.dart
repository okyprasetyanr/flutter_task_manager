import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/shared/style/text_size.dart';

class SharedRemainingDays extends StatelessWidget {
  final DateTime dueDate;

  const SharedRemainingDays({super.key, required this.dueDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadline = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final differenceInDays = deadline.difference(today).inDays;

    String statusText;
    Color backgroundColor;
    TextStyle textStyle;
    Icon icon;
    double size = 18;
    Color color;

    if (differenceInDays < 0) {
      statusText = "Overdue (${differenceInDays.abs()} days ago)";
      backgroundColor = AppPropertyColor.red.withValues(alpha: 0.1);
      textStyle = lv1TextStyleRed;
      icon = Icon(Icons.error_outline, color: AppPropertyColor.red, size: size);
      color = AppPropertyColor.red;
    } else if (differenceInDays == 0) {
      statusText = "Due Today";
      backgroundColor = AppPropertyColor.secondPrimary.withValues(alpha: 0.1);
      textStyle = lv1TextStyleSecondPrimary;
      icon = Icon(
        Icons.access_time_filled,
        color: AppPropertyColor.secondPrimary,
        size: size,
      );
      color = AppPropertyColor.secondPrimary;
    } else if (differenceInDays == 1) {
      statusText = "Due Tomorrow";
      backgroundColor = AppPropertyColor.secondPrimary.withValues(alpha: 0.1);
      textStyle = lv1TextStyleSecondPrimary;
      icon = Icon(
        Icons.access_time,
        color: AppPropertyColor.secondPrimary,
        size: size,
      );
      color = AppPropertyColor.secondPrimary;
    } else if (differenceInDays <= 3) {
      statusText = "$differenceInDays days left (Urgent)";
      backgroundColor = AppPropertyColor.secondPrimary.withValues(alpha: 0.1);
      textStyle = lv1TextStyleSecondPrimary;
      icon = Icon(
        Icons.warning_amber_rounded,
        color: AppPropertyColor.secondPrimary,
        size: size,
      );
      color = AppPropertyColor.secondPrimary;
    } else {
      statusText = "$differenceInDays days left";
      backgroundColor = AppPropertyColor.secondPrimary.withValues(alpha: 0.2);
      textStyle = lv1TextStylePrimary;
      icon = Icon(
        Icons.calendar_today_rounded,
        color: AppPropertyColor.primary,
        size: size,
      );
      color = AppPropertyColor.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(statusText, style: textStyle),
        ],
      ),
    );
  }
}
