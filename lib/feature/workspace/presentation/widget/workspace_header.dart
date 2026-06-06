import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/header/custom_row_header.dart';
import 'package:task_manager/shared/widget/loading/custom_loading.dart';

class WorkspaceHeader extends StatelessWidget {
  const WorkspaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRowHeader(
      widgetLeft: Text('Ruang Kerja', style: titleTextStyle),
      widgetRight: BlocSelector<WorkspaceBloc, WorkspaceState, String?>(
        selector: (state) =>
            state is WorkspaceStateLoaded ? state.companyName : null,
        builder: (context, state) => state != null
            ? Text(
                "Perusahaan $state",
                style: lv1TextStyle,
                textAlign: TextAlign.end,
              )
            : SizedBox(height: 20, width: 20, child: CustomLoading()),
      ),
    );
  }
}
