import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/header/custom_row_header.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';

class WorkspaceHeader extends StatelessWidget {
  const WorkspaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRowHeader(
      logoutIcon: true,
      widgetLeft: Text('Workspace', style: titleTextStyleWhite),
      widgetRight: BlocSelector<WorkspaceBloc, WorkspaceState, String?>(
        selector: (state) =>
            state is WorkspaceStateLoaded ? state.companyName : null,
        builder: (context, state) => state != null
            ? Text(
                "$state Company",
                style: lv1TextStyleWhite,
                textAlign: TextAlign.end,
              )
            : SizedBox(height: 20, width: 20, child: const CustomLoading()),
      ),
    );
  }
}
