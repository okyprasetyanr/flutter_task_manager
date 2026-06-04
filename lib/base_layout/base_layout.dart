import 'package:flutter/material.dart';
import 'package:task_manager/app_properties/app_properties.dart';

class BaseLayout extends StatelessWidget {
  final Widget uiPage;
  const BaseLayout({super.key, required this.uiPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        backgroundColor: AppPropertyColor.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: uiPage,
        ),
      ),
    );
  }
}
