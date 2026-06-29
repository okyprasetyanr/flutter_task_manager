import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/widget/member_list/widget_member_list.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/feature/workspace/presentation/widget/workspace_botshet_content.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

class WorkspaceListWorkspace extends StatelessWidget {
  const WorkspaceListWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      WorkspaceBloc,
      WorkspaceState,
      (Set<ModelWorkspaceMerge>, EnumStatusState, Set<ModelUser>)
    >(
      selector: (state) => state is WorkspaceStateLoaded
          ? (state.dataWorkspace, state.status, state.dataUser)
          : (const {}, EnumStatusState.loading, const {}),
      builder: (context, state) {
        return CustomListViewBuilderV<ModelWorkspaceMerge>(
          data: state.$1.toList(),
          status: state.$2,
          content: (data, status) => [
            Text(data.dataWorkspace.name, style: lv1TextStyleBold),
            const SizedBox(height: 4),
            Text(data.dataWorkspace.description, style: lv05TextStyle),
            SizedBox(
              height: 30,
              child:
                  data.dataMember.isEmpty &&
                      status == EnumStatusState.synchronize
                  ? const CustomLoading()
                  : data.dataMember.isEmpty && status == EnumStatusState.none
                  ? CustomTextEmpty()
                  : SharedWidgetMemberList(
                      data: state.$3
                          .where(
                            (element) => data.dataMember
                                .map((e) => e.userId)
                                .contains(element.id),
                          )
                          .toSet(),
                      status: status,
                    ),
            ),
          ],
          onPressed: (data) => RoutesNavigator(
            context: context,
            routeName: RoutesEnum.workspaceDetail,
            replace: false,
            arguments: {'dataTransfered': data},
          ).navigate(),
          onOption: (data) {
            context.read<WorkspaceBloc>().add(
              WorkspaceEventSelectedData(data: data),
            );
            return customBottomSheet(
              context: context,
              resetItemForm: () {
                context.read<WorkspaceBloc>().add(
                  WorkspaceEventResetSelected(),
                );
              },
              content: (scrollController) {
                final bloc = context.read<WorkspaceBloc>();
                return BlocProvider.value(
                  value: bloc,
                  child: WorkspaceBotshetContent(
                    scrollController: scrollController,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
