import 'package:flutter/material.dart';
import 'package:task_manager/feature/main_menu/presentation/ui/ui_main_menu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UiMainMenu();
  }
}
