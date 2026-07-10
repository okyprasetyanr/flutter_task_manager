import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/icon_size.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading_linear.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';

class WorkspaceBotshetContent extends StatefulWidget {
  final ScrollController scrollController;
  const WorkspaceBotshetContent({super.key, required this.scrollController});

  @override
  State<WorkspaceBotshetContent> createState() =>
      _WorkspaceBotshetContentState();
}

class _WorkspaceBotshetContentState extends State<WorkspaceBotshetContent> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  bool _initialized = false;
  final listUser = <(ModelUser, EnumWorkspaceRole)>[].obs;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceBloc, WorkspaceState>(
      listenWhen: (previous, current) =>
          previous is WorkspaceStateLoaded &&
          current is WorkspaceStateLoaded &&
          previous.status == EnumStatusState.synchronize &&
          current.status == EnumStatusState.none,
      listener: (context, state) {
        Navigator.pop(context);
      },
      child: BlocSelector<WorkspaceBloc, WorkspaceState, (ModelWorkspaceMerge?, Set<ModelUser>)>(
        selector: (state) => state is WorkspaceStateLoaded
            ? (state.selectedWorkspace, state.dataUser)
            : (null, const {}),
        builder: (context, data) {
          if (!_initialized && data.$1 != null) {
            _initialized = true;
            nameController.text = data.$1!.dataWorkspace.name;
            descriptionController.text = data.$1!.dataWorkspace.description;

            final dataMembers = data.$1?.dataMember ?? {};
            final memberRoleMap = {
              for (var member in dataMembers) member.userId: member.role,
            };

            listUser.addAll(
              data.$2
                  .where((element) => memberRoleMap.containsKey(element.id))
                  .map((e) => (e, memberRoleMap[e.id]!)),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Form Workspace", style: titleTextStyle),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: nameController,
                          label: "Name",
                          validator: (value) =>
                              value!.isEmpty ? "Name required!" : null,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: descriptionController,
                          label: "Description",
                          validator: (value) =>
                              value!.isEmpty ? "Description required!" : null,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("List Member", style: lv2TextStyle),
                            Expanded(
                              child: Obx(() {
                                return ListView.builder(
                                  controller: widget.scrollController,
                                  shrinkWrap: true,
                                  itemCount: listUser.length,
                                  itemBuilder: (context, listMemberIndex) {
                                    final data = listUser.elementAt(
                                      listMemberIndex,
                                    );
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Material(
                                            elevation: 2,
                                            color: AppPropertyColor.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        AppPropertyColor.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),

                                                    child: ListView(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                      shrinkWrap: true,
                                                      children: [
                                                        Text(
                                                          "Member Role",
                                                          style: titleTextStyle,
                                                        ),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              EnumWorkspaceRole
                                                                  .values
                                                                  .length,
                                                          itemBuilder: (context, index) => CustomButtonIcon(
                                                            left: true,
                                                            icon: Icon(
                                                              Icons
                                                                  .admin_panel_settings_rounded,
                                                            ),
                                                            backgroundColor:
                                                                AppPropertyColor
                                                                    .white,
                                                            label: Text(
                                                              EnumWorkspaceRole
                                                                  .values[index]
                                                                  .text,
                                                            ),
                                                            onPressed: () {
                                                              listUser[listMemberIndex] = (
                                                                data.$1,
                                                                EnumWorkspaceRole
                                                                    .values[index],
                                                              );
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 6,
                                                  top: 6,
                                                  bottom: 6,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color:
                                                                    AppPropertyColor
                                                                        .black,
                                                                size:
                                                                    lv1IconSize,
                                                              ),
                                                              Text(
                                                                data.$1.name,
                                                                style:
                                                                    lv05TextStyle,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                          Material(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                            elevation: 3,
                                                            color:
                                                                AppPropertyColor
                                                                    .white,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    5,
                                                                  ),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .admin_panel_settings_rounded,
                                                                    color: AppPropertyColor
                                                                        .black,
                                                                    size:
                                                                        lv1IconSize,
                                                                  ),
                                                                  Text(
                                                                    data
                                                                        .$2
                                                                        .text,
                                                                    style:
                                                                        lv05TextStyle,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    CustomButton(
                                                      backgroundColor:
                                                          AppPropertyColor
                                                              .white,
                                                      onPressed: () =>
                                                          listUser.removeWhere(
                                                            (element) =>
                                                                element.$1.id ==
                                                                data.$1.id,
                                                          ),
                                                      child: Icon(
                                                        Icons.close_rounded,
                                                        color: AppPropertyColor
                                                            .red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: BlocSelector<WorkspaceBloc, WorkspaceState, Set<ModelUser>>(
                          selector: (state) => state is WorkspaceStateLoaded
                              ? state.filteredUser
                              : {},
                          builder: (context, state) => Column(
                            children: [
                              CustomTextField(
                                controller: searchController,
                                label: "Search new Member",
                                onChanged: (value) =>
                                    context.read<WorkspaceBloc>().add(
                                      WorkspaceEventSearchMember(search: value),
                                    ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: widget.scrollController,
                                  shrinkWrap: true,
                                  itemCount: state.length,
                                  itemBuilder: (context, index) {
                                    final data = state.elementAt(index);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 7,
                                      ),
                                      child: Material(
                                        color: AppPropertyColor.white,
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(8),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          onTap: () =>
                                              listUser.any(
                                                (element) =>
                                                    element.$1.id == data.id,
                                              )
                                              ? customSnackBar(
                                                  context,
                                                  "${data.name} was added!",
                                                  top: true,
                                                )
                                              : () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            AppPropertyColor
                                                                .white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        child: ListView(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                10,
                                                              ),
                                                          shrinkWrap: true,
                                                          children: [
                                                            Text(
                                                              "Member Role",
                                                              style:
                                                                  titleTextStyle,
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Expanded(
                                                              child: ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    EnumWorkspaceRole
                                                                        .values
                                                                        .length,
                                                                itemBuilder: (context, index) => CustomButtonIcon(
                                                                  left: true,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .admin_panel_settings_rounded,
                                                                  ),
                                                                  backgroundColor:
                                                                      AppPropertyColor
                                                                          .white,
                                                                  label: Text(
                                                                    EnumWorkspaceRole
                                                                        .values[index]
                                                                        .text,
                                                                  ),
                                                                  onPressed: () {
                                                                    listUser.add((
                                                                      data,
                                                                      EnumWorkspaceRole
                                                                          .values[index],
                                                                    ));
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  data.name,
                                                  style: lv05TextStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Obx(
                                                  () =>
                                                      listUser.any(
                                                        (element) =>
                                                            element.$1.id ==
                                                            data.id,
                                                      )
                                                      ? Icon(
                                                          Icons
                                                              .check_circle_outline_rounded,
                                                          size: lv2IconSize,
                                                          color:
                                                              AppPropertyColor
                                                                  .primary,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .radio_button_unchecked_rounded,
                                                          size: lv2IconSize,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                BlocSelector<WorkspaceBloc, WorkspaceState, EnumStatusState>(
                  selector: (state) => state is WorkspaceStateLoaded
                      ? state.status
                      : EnumStatusState.none,
                  builder: (context, state) =>
                      state == EnumStatusState.synchronize
                      ? const CustomLoadingLinear()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (data.$1 != null)
                              Expanded(
                                child: CustomButtonIcon(
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: AppPropertyColor.white,
                                  ),
                                  backgroundColor: AppPropertyColor.red,
                                  label: Text(
                                    "Delete",
                                    style: lv1TextStyleWhite,
                                  ),
                                  padding: true,
                                  onPressed: () => context
                                      .read<WorkspaceBloc>()
                                      .add(WorkspaceEventDeleteWorkspace()),
                                ),
                              ),
                            Expanded(
                              child: CustomButtonIcon(
                                icon: Icon(
                                  Icons.check_rounded,
                                  color: AppPropertyColor.white,
                                ),
                                backgroundColor: AppPropertyColor.primary,
                                label: Text(
                                  data.$1 != null ? "Update" : "Add",
                                  style: lv1TextStyleWhite,
                                ),
                                padding: true,
                                onPressed: () {
                                  if (!_keyForm.currentState!.validate()) {
                                    return;
                                  }
                                  data.$1 != null
                                      ? context.read<WorkspaceBloc>().add(
                                          WorkspaceEventUpdateWorkspace(
                                            name: nameController.text,
                                            description:
                                                descriptionController.text,
                                            contributor: listUser.toSet(),
                                          ),
                                        )
                                      : context.read<WorkspaceBloc>().add(
                                          WorkspaceEventCreateWorkspace(
                                            name: nameController.text,
                                            description:
                                                descriptionController.text,
                                            contributor: listUser.toSet(),
                                          ),
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
