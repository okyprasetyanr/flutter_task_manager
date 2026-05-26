import 'package:flutter/material.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/style/text_size.dart';

class UiMainMenu extends StatefulWidget {
  const UiMainMenu({super.key});

  @override
  State<UiMainMenu> createState() => _UiMainMenuState();
}

class _UiMainMenuState extends State<UiMainMenu> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(uiPage: uiPage());
  }

  Widget uiPage() {
    return Column(
      children: [
        Text("Ringkas Task", style: titleTextStyle),
        Image.asset("assets/"),
        Expanded(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Column(children: []),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
