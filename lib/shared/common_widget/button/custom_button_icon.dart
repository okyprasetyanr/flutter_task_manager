import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';

class CustomButtonIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? label;
  final Color? backgroundColor;
  final Icon? icon;
  final bool left;
  final bool rightIcon;
  final bool padding;
  const CustomButtonIcon({
    super.key,
    this.onPressed,
    this.label,
    this.backgroundColor,
    this.icon,
    this.left = false,
    this.rightIcon = false,
    this.padding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding
          ? const EdgeInsets.only(left: 5, right: 0, bottom: 5, top: 0)
          : const EdgeInsets.only(),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: label ?? const SizedBox.shrink(),
        icon: icon,
        iconAlignment: rightIcon ? IconAlignment.end : IconAlignment.start,
        style: ElevatedButton.styleFrom(
          elevation: 4,
          visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
          backgroundColor: backgroundColor,
          minimumSize: const Size(0, 0),
          alignment: left ? Alignment.centerLeft : Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
          shape: AppPropertyBorderRadius.rounded10,
        ),
      ),
    );
  }
}
