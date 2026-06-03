import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/core/services/api_services.dart';
import 'package:task_manager/feature/main_menu/data/models/model_project.dart';
import 'package:task_manager/feature/main_menu/presentation/bloc/main_menu_bloc.dart';
import 'package:task_manager/feature/main_menu/presentation/bloc/main_menu_state.dart';
import 'package:task_manager/feature/project_detail/data/data_resource/local/local_repository.dart';
import 'package:task_manager/feature/project_detail/data/data_resource/remote/remote_repository.dart';
import 'package:task_manager/feature/project_detail/data/repository_imp/repository_imp.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_event.dart';
import 'package:task_manager/feature/project_detail/presentation/page/page_project_detail.dart';
import 'package:task_manager/shared/helper/common_helper.dart';
import 'package:task_manager/shared/widget/loading/widget_loading.dart';
import 'package:task_manager/shared/widget/text/custom_text_empty.dart';
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
                child: BlocSelector<MainMenuBloc, MainMenuState, List<ModelProject>?>(
                  selector: (state) =>
                      state is MainMenuLoaded ? state.dataProject : null,
                  builder: (context, state) {
                    return state == null
                        ? customLoading()
                        : state.isEmpty
                        ? customTextEmpty()
                        : ListView.builder(
                            itemCount: state.length,
                            itemBuilder: (context, index) {
                              final data = state[index];
                              return Card(
                                color: AppPropertyColor.white,
                                elevation: 4,
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      final apiService = context
                                          .read<ApiServices>();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return RepositoryProvider<
                                              ProjectDetailRepository
                                            >(
                                              create: (_) =>
                                                  ProjectDetailRepositoryImp(
                                                    remote: RemoteProjectDetail(
                                                      apiServices: apiService,
                                                    ),
                                                    project: data,
                                                    local: LocalProjectDetail(),
                                                  ),
                                              child: BlocProvider(
                                                create: (context) =>
                                                    ProjectDetailBloc(
                                                      context
                                                          .read<
                                                            ProjectDetailRepository
                                                          >(),
                                                    )..add(
                                                      ProjectDetailGetData(),
                                                    ),
                                                child:
                                                    const PageProjectDetail(),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },

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
                                                      text:
                                                          data.projectCreatedBy,
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
