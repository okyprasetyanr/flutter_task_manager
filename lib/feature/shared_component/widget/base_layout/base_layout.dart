// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:task_manager/core/app_properties/app_properties.dart';

class BaseLayout extends StatelessWidget {
  final Widget uiPage;
  final Widget? widgetNavigation;
  final Widget? fab;
  final Widget? background;
  const BaseLayout({
    super.key,
    required this.uiPage,
    this.widgetNavigation,
    this.fab,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        floatingActionButton: fab,
        backgroundColor: AppPropertyColor.white,
        body: Stack(
          children: [
            if (background != null)
              Positioned(top: 0, left: 0, right: 0, child: background!),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: uiPage,
              ),
            ),
            if (widgetNavigation != null) widgetNavigation!,
          ],
        ),
      ),
    );
  }
}
