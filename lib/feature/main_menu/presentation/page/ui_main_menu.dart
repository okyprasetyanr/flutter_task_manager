import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/main_menu/domain/models/model_project.dart';
import 'package:task_manager/feature/main_menu/presentation/bloc/main_menu_bloc.dart';
import 'package:task_manager/feature/main_menu/presentation/bloc/main_menu_state.dart';
import 'package:task_manager/helper/common_helper.dart';
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
        Image.asset("assets/logo.png", height: 50),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: BlocSelector<MainMenuBloc, MainMenuState, List<ModelProject>>(
                  selector: (state) =>
                      state is MainMenuLoaded ? state.dataProject : [],
                  builder: (context, state) {
                    return state.isEmpty
                        ? Center(child: LinearProgressIndicator())
                        : ListView.builder(
                            itemCount: state.length,
                            itemBuilder: (context, index) {
                              final data = state[index];
                              return Card(
                                color: AppPropertyColor.white,
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.projectName,
                                            style: lv05TextStyle,
                                          ),
                                          Text(
                                            data.projectType,
                                            style: lv05TextStyle,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Start: ${formatDate(date: data.projectStart, minute: false)}",
                                            style: lv05TextStyle,
                                          ),
                                          Text(
                                            "End: ${formatDate(date: data.projectEnd, minute: false)}",
                                            style: lv05TextStyle,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.projectStatus,
                                            style: lv05TextStyle,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Created By: ",
                                                  style: lv05TextStyle,
                                                ),
                                                TextSpan(
                                                  text: data.projectCreatedBy,
                                                  style: lv1TextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
