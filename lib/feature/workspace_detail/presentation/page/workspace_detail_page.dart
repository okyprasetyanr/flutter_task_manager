import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/shared_component/widget/base_layout/base_layout.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/botshet_content/workspace_detail_botshet_content.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_filter_type.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_header.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_list_project.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/navigator_content/navigator_content.dart';
import 'package:task_manager/feature/workspace_detail/presentation/widget/workspace_detail_search_project.dart';
import 'package:task_manager/shared/common_widget/multi_fab/custom_multi_fab.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/model/model_fab.dart';
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
    return BaseLayout(
      uiPage: uiPage(),
      widgetNavigation: navigationGesture(),
      background: Image.asset("assets/bg.png", fit: BoxFit.fill),
      isFill: true,
      fab: CustomMultiFab(
        items: [
          CustomFabItem(
            icon: Icons.menu_rounded,
            title: "Menu",
            onTap: () => isOpen.value = !isOpen.value,
          ),
          CustomFabItem(
            icon: Icons.add,
            title: "Add",
            onTap: () => customBottomSheet(
              context: context,
              resetItemForm: () {},
              content: (scrollController) {
                return BlocProvider.value(
                  value: context.read<WorkspaceDetailBloc>(),
                  child: WorkspaceDetailBotshetContent(
                    scrollController: scrollController,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget uiPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkspaceDetailHeader(),
        WorkspaceDetailFilterType(),
        WorkspaceDetailSearchProject(),
        Expanded(child: WorkspaceDetailListProject()),
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
