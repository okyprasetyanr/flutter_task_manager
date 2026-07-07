import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_h.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WorkspaceListMember extends StatelessWidget {
  const WorkspaceListMember({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, ModelUser?>(
      selector: (state) =>
          state is WorkspaceStateLoaded ? state.dataAccount : null,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hi, ${state?.name ?? "..."}", style: lvMediumstyleWhite),
          Text("Welcome to Ringkas Task", style: lv4TextStyleWhite),
          const SizedBox(height: 10),
          Material(
            borderRadius: BorderRadius.circular(8),
            color: AppPropertyColor.white,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "All Member in this Company",
                          style: lv1TextStyleBold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        child:
                            BlocSelector<
                              WorkspaceBloc,
                              WorkspaceState,
                              (EnumStatusState, Set<ModelUser>)
                            >(
                              selector: (state) => state is WorkspaceStateLoaded
                                  ? (state.status, state.dataUser)
                                  : (EnumStatusState.none, {}),
                              builder: (context, state) =>
                                  CustomListViewBuilderH(
                                    status: state.$1,
                                    data: state.$2.toList(),
                                    getName: (data) => data.name,
                                    leftWidget: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: AppPropertyColor.white,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: "",
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                                  Icons.person,
                                                  size: 15,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                CustomButton(
                  backgroundColor: AppPropertyColor.white,
                  child: Icon(
                    Icons.person_add_alt_1,
                    color: AppPropertyColor.primary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
