import 'package:flutter/material.dart';

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
      ],
    );
  }
}
