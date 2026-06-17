import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_bloc.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_state.dart';
import 'package:task_manager/feature/activity/presentation/widget/activitty_list_activity.dart';
import 'package:task_manager/feature/activity/presentation/widget/activity_header.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';
import 'package:task_manager/shared/navigator_content/navigator_content.dart';
import 'package:task_manager/shared/style/icon_size.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/navigation_gesture/widget_navigation_gesture.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
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
        ActivityHeader(),
        Expanded(child: ActivittyListActivity()),
      ],
    );
  }

  Widget navigationGesture() {
    return BlocSelector<ActivityBloc, ActivityState, ModelWorkspace?>(
      selector: (state) {
        return state is ActivityStateLoaded ? state.dataWorkspace : null;
      },
      builder: (context, workspace) {
        return NavigationGesture(
          arguments: {'dataTransfered': workspace},
          currentPage: RoutesEnum.activity,
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
