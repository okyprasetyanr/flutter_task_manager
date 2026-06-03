import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/project_detail/data/model/model_members.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/widget/loading/widget_loading.dart';
import 'package:task_manager/shared/widget/text/custom_text_empty.dart';
import 'package:task_manager/style/text_size.dart';

class UiProjectMemberLayout extends StatefulWidget {
  const UiProjectMemberLayout({super.key});

  @override
  State<UiProjectMemberLayout> createState() => _UiProjectMemberLayoutState();
}

class _UiProjectMemberLayoutState extends State<UiProjectMemberLayout> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child:
            BlocSelector<
              ProjectDetailBloc,
              ProjectDetailState,
              List<ModelProjectMember>?
            >(
              selector: (state) =>
                  state is ProjectDetailLoaded ? state.dataMember : null,
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
                              child: ListTile(
                                title: Text(data.name, style: lv05TextStyle),
                                subtitle: Text(data.role, style: lv05TextStyle),
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
