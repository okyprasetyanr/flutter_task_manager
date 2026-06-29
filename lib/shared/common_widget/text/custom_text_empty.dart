// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:task_manager/shared/style/text_size.dart';

class CustomTextEmpty extends StatelessWidget {
  final TextStyle? textStyle;
  final String? text;
  const CustomTextEmpty({super.key, this.text, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${text ?? "Data"} is Empty!",
        style: textStyle ?? lv05TextStyle,
      ),
    );
  }
}
