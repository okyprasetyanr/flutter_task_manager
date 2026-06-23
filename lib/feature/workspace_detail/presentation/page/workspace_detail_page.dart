import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/widget/base_layout/base_layout.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/feature/shared_component/widget/floating_button_add/floating_button_add.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_botshet_content.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_header.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_list_project.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/navigator_content/navigator_content.dart';
import 'package:task_manager/shared/style/icon_size.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/navigation_gesture/widget_navigation_gesture.dart';

class WorkspaceDetailPage extends StatefulWidget {
  const WorkspaceDetailPage({super.key});

  @override
  State<WorkspaceDetailPage> createState() => _WorkspaceDetailPageState();
}

class _WorkspaceDetailPageState extends State<WorkspaceDetailPage> {
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
        WorkspaceDetailHeader(),
        Expanded(child: WorkspaceDetailListProject()),
        FloatingButtonAdd<WorkspaceDetailBloc>(
          content: (scrollController) =>
              WorkspaceDetailBotshetContent(scrollController: scrollController),
        ),
      ],
    );
  }

  Widget navigationGesture() {
    return BlocSelector<
      WorkspaceDetailBloc,
      WorkspaceDetailState,
      (ModelWorkspaceMerge?, Set<ModelUser>)
    >(
      selector: (state) {
        return state is WorkspaceDetailStateLoaded
            ? (state.workspace, state.dataUser)
            : (null, const {});
      },
      builder: (context, state) {
        return NavigationGesture(
          arguments: {'dataTransfered': state.$1},
          currentPage: RoutesEnum.workspaceDetail,
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
