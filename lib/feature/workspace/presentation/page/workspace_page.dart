import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/model/model_workspace.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/button/custom_button.dart';
import 'package:task_manager/shared/widget/loading/widget_loading.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(uiPage: uiPage());
  }

  Widget uiPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ruang Kerja', style: titleTextStyle),
              BlocSelector<WorkspaceBloc, WorkspaceState, String?>(
                selector: (state) =>
                    state is WorkspaceStateLoaded ? state.companyName : null,
                builder: (context, state) => state != null
                    ? Text(
                        "Perusahaan $state",
                        style: lv1TextStyle,
                        textAlign: TextAlign.end,
                      )
                    : SizedBox(height: 20, width: 20, child: customLoading()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child:
              BlocSelector<WorkspaceBloc, WorkspaceState, List<ModelWorkspace>>(
                selector: (state) =>
                    state is WorkspaceStateLoaded ? state.dataWorkspace : [],
                builder: (context, state) {
                  if (state.isEmpty) {
                    return Center(
                      child: Text(
                        "Ruang Kerja masih kosong!",
                        style: lv1TextStyle,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        final data = state[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CustomButton(
                            backgroundColor: AppPropertyColor.white,
                            padding: true,
                            onPressed: () {},
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.workspaceName,
                                    style: lv05TextStyle,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data.workspaceDescription,
                                    style: lv05TextStyle.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
        ),
      ],
    );
  }
}
