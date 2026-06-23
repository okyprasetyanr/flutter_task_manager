import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_bloc.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_state.dart';
import 'package:task_manager/feature/history_task/presentation/widget/history_task_header.dart';
import 'package:task_manager/feature/history_task/presentation/widget/history_task_list_history.dart';
import 'package:task_manager/feature/shared_component/navigator_content/navigator_content.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/style/icon_size.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/navigation_gesture/widget_navigation_gesture.dart';

class HistoryTaskPage extends StatefulWidget {
  const HistoryTaskPage({super.key});

  @override
  State<HistoryTaskPage> createState() => _HistoryTaskPageState();
}

class _HistoryTaskPageState extends State<HistoryTaskPage> {
  final isOpen = ValueNotifier<bool>(false);
  final currentPage = ValueNotifier<bool>(true);
  @override
  void dispose() {
    currentPage.dispose();
    isOpen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(uiPage: uiPage(), widgetNavigation: navigationGesture());
  }

  Widget uiPage() {
    return Column(
      children: [
        CustomButtonIcon(
          backgroundColor: AppPropertyColor.primary,
          icon: const Icon(
            Icons.menu_rounded,
            color: AppPropertyColor.white,
            size: lv2IconSize,
          ),
          label: Text("Menu", style: lv05TextStyleWhite),
          onPressed: () {
            isOpen.value = !isOpen.value;
          },
        ),
        HistoryTaskHeader(),
        Expanded(child: HistoryTaskListHistory()),
      ],
    );
  }

  Widget navigationGesture() {
    return BlocSelector<
      HistoryTaskBloc,
      HistoryTaskState,
      ModelWorkspaceMerge?
    >(
      selector: (state) {
        return state is HistoryTaskStateLoaded ? state.workspace : null;
      },
      builder: (context, workspace) {
        return NavigationGesture(
          arguments: {'dataTransfered': workspace},
          currentPage: RoutesEnum.historyTask,
          attContent: NavigatorContent.activityHistoryTaskProjectDetail,
          isOpen: isOpen,
          close: () {
            isOpen.value = false;
          },
        );
      },
    );
  }
}
