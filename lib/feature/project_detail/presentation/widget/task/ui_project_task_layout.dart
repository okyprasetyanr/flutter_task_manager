import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/data/model/model_tasks.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/shared/helper/common_helper.dart';
import 'package:task_manager/shared/widget/loading/widget_loading.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/widget/text/custom_text_empty.dart';
import 'package:task_manager/style/text_size.dart';

class UiProjectTaskLayout extends StatelessWidget {
  const UiProjectTaskLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child:
            BlocSelector<
              ProjectDetailBloc,
              ProjectDetailState,
              List<ModelProjectTask>?
            >(
              selector: (state) =>
                  state is ProjectDetailLoaded ? state.dataTask : null,
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
                                      Text(data.title, style: lv05TextStyle),
                                      Text(
                                        data.priority?.name ??
                                            "Level Diketahui",
                                        style: lv05TextStyle,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatDate(
                                          date: data.dueDate,
                                          minute: false,
                                        ),
                                        style: lv05TextStyle,
                                      ),
                                      Text(
                                        data.status?.name ?? "Status Diketahui",
                                        style: lv05TextStyle,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.description,
                                        style: lv05TextStyle,
                                      ),
                                      Text(
                                        data.assignedTo,
                                        style: lv05TextStyle,
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
    );
  }
}
