import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget uiPage;
  const BaseLayout({super.key, required this.uiPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(bottom: true, top: true, child: Scaffold(body: uiPage));
  }
}
