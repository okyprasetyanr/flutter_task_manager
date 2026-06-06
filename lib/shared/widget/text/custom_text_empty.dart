import 'package:flutter/material.dart';
import 'package:task_manager/shared/style/text_size.dart';

class CustomTextEmpty extends StatelessWidget {
  const CustomTextEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Data masih Kosong!", style: lv05TextStyle));
  }
}
