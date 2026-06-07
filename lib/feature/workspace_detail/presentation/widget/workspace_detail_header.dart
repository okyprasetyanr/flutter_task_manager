import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/header/custom_row_header.dart';
import 'package:task_manager/shared/widget/loading/custom_loading.dart';

class WorkspaceDetailHeader extends StatelessWidget {
  const WorkspaceDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRowHeader(
      widgetLeft: Text('Detail Ruang Kerja', style: titleTextStyle),
      widgetRight:
          BlocSelector<
            WorkspaceDetailBloc,
            WorkspaceDetailState,
            (String?, EnumStatusState)
          >(
            selector: (state) => state is WorkspaceDetailStateLoaded
                ? (state.dataWorkspace?.workspaceName ?? "...", state.status)
                : (null, EnumStatusState.loading),
            builder: (context, state) => state.$2 == EnumStatusState.loading
                ? CustomLoading()
                : Text(
                    "Perusahaan ${state.$1}",
                    style: lv1TextStyle,
                    textAlign: TextAlign.end,
                  ),
          ),
    );
  }
}
