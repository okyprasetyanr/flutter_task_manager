import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/main_menu/data/domain/models/model_project.dart';
import 'package:task_manager/feature/main_menu/logic/main_menu_bloc.dart';
import 'package:task_manager/feature/main_menu/logic/main_menu_state.dart';
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
                  child:
                      BlocSelector<
                        MainMenuBloc,
                        MainMenuState,
                        List<ModelProject>
                      >(
                        selector: (state) =>
                            state is MainMenuLoaded ? state.dataProject : [],
                        builder: (context, state) {
                          return ListView(
                            children: [
                              ...state.map(
                                (e) => Column(
                                  children: [
                                    Text(e.projectName, style: lv05TextStyle),
                                    Text(e.projectType, style: lv05TextStyle),
                                    Text(e.projectStatus, style: lv05TextStyle),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
