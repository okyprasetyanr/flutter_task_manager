import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Widget? child;
  final bool moreRadius;
  final bool padding;
  const CustomButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.child,
    this.moreRadius = false,
    this.padding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
          elevation: const WidgetStatePropertyAll(4),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          minimumSize: const WidgetStatePropertyAll(Size(0, 0)),
          padding: padding
              ? const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                )
              : const WidgetStatePropertyAll(EdgeInsets.only()),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(moreRadius ? 15 : 10),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
