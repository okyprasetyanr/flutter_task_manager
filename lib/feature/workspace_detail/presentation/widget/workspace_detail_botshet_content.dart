import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/shared_component/widget/drop_down/widget_drop_down.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_bloc.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_event.dart';
import 'package:task_manager/feature/workspace_detail/presentation/bloc/workspace_detail_state.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/date_picker/custom_date_picker.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/style/icon_size.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WorkspaceDetailBotshetContent extends StatefulWidget {
  final ScrollController scrollController;
  const WorkspaceDetailBotshetContent({
    super.key,
    required this.scrollController,
  });

  @override
  State<WorkspaceDetailBotshetContent> createState() =>
      _WorkspaceDetailBotshetContentState();
}

class _WorkspaceDetailBotshetContentState
    extends State<WorkspaceDetailBotshetContent> {
  final pickedStart = ValueNotifier<DateTime>(DateTime.now());
  final pickedEnd = ValueNotifier<DateTime>(DateTime.now());
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final searchController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  final projectStatus = ValueNotifier<EnumProjectStatus>(
    EnumProjectStatus.unknown,
  );
  bool _initialized = false;
  final listUser = <(ModelUser, EnumProjectRole)>[].obs;

  DateTime createdAt = DateTime.now();
  @override
  void dispose() {
    pickedStart.dispose();
    pickedEnd.dispose();
    nameController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceDetailBloc, WorkspaceDetailState>(
      listenWhen: (previous, current) =>
          previous is WorkspaceDetailStateLoaded &&
          current is WorkspaceDetailStateLoaded &&
          previous.status == EnumStatusState.synchronize &&
          current.status == EnumStatusState.none,
      listener: (context, state) {
        Navigator.pop(context);
      },
      child:
          BlocSelector<
            WorkspaceDetailBloc,
            WorkspaceDetailState,
            (ModelProjectMerge?, Set<ModelUser>)
          >(
            selector: (state) {
              if (state is WorkspaceDetailStateLoaded) {
                return (state.selectedProject, state.dataUser);
              }
              return (null, const {});
            },
            builder: (context, data) {
              if (!_initialized && data.$1 != null) {
                _initialized = true;
                nameController.text = data.$1!.dataProject.name;
                typeController.text = data.$1!.dataProject.type;
                projectStatus.value = data.$1!.dataProject.status;
                pickedStart.value = data.$1!.dataProject.start;
                pickedEnd.value = data.$1!.dataProject.end;
                createdAt = data.$1!.dataProject.createdAt;
                final dataMembers = data.$1?.dataMember ?? {};
                final memberRoleMap = {
                  for (var member in dataMembers) member.userId: member.role,
                };

                listUser.addAll(
                  data.$2
                      .where((element) => memberRoleMap.containsKey(element.id))
                      .map((e) => (e, memberRoleMap[e.id]!)),
                );
                devLog(
                  "Log WorkspaceDetailBotShetContent: data: ${data.$1!.dataProject.status}",
                );
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Project Form", style: titleTextStyle),
                    const SizedBox(height: 10),
                    Form(
                      key: _keyForm,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: "Name",
                            controller: nameController,
                            enable: data.$1 == null,
                            validator: (value) => value!.isEmpty
                                ? "Project Name required!"
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: "Type",
                                  controller: typeController,
                                  validator: (value) =>
                                      value!.isEmpty ? "Type required!" : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child:
                                    ValueListenableBuilder<EnumProjectStatus>(
                                      valueListenable: projectStatus,
                                      builder: (context, value, child) =>
                                          WidgetDropDown<EnumProjectStatus>(
                                            extension: (extension) =>
                                                extension.text,
                                            initialValue: value,
                                            filters: EnumProjectStatus.values,
                                            text: "Status",
                                            selectedValue: (selectedEnum) =>
                                                projectStatus.value =
                                                    selectedEnum,
                                          ),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            backgroundColor: AppPropertyColor.white,
                            onPressed: () async => await customDatePicker(
                              dateEnd: false,
                              text: "Date Start",
                              context: context,
                              selectedDate: pickedStart.value,
                              picked: (picked) => pickedStart.value = picked,
                            ),
                            child: Column(
                              children: [
                                Text("Start", style: lv05TextStyle),
                                ValueListenableBuilder(
                                  valueListenable: pickedStart,
                                  builder: (context, value, child) => Text(
                                    HelperDateConvert.toDisplayUI(date: value),
                                    style: lv1TextStyleBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomButton(
                            backgroundColor: AppPropertyColor.red,
                            onPressed: () async => await customDatePicker(
                              dateEnd: true,
                              text: "Date End",
                              context: context,
                              selectedDate: pickedEnd.value,
                              picked: (picked) => pickedEnd.value = picked,
                            ),
                            child: Column(
                              children: [
                                Text("End", style: lv05TextStyleWhite),
                                ValueListenableBuilder(
                                  valueListenable: pickedEnd,
                                  builder: (context, value, child) => Text(
                                    HelperDateConvert.toDisplayUI(date: value),
                                    style: lv1TextStyleWhiteBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
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
                                                        Text("Member Role"),
                                                        Expanded(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                EnumProjectRole
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
                                                                EnumProjectRole
                                                                    .values[index]
                                                                    .text,
                                                              ),
                                                              onPressed: () {
                                                                listUser[listMemberIndex] = (
                                                                  data.$1,
                                                                  EnumProjectRole
                                                                      .values[index],
                                                                );
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
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child:
                                BlocSelector<
                                  WorkspaceDetailBloc,
                                  WorkspaceDetailState,
                                  Set<ModelUser>
                                >(
                                  selector: (state) =>
                                      state is WorkspaceDetailStateLoaded
                                      ? state.filteredUser
                                      : {},
                                  builder: (context, state) => Column(
                                    children: [
                                      CustomTextField(
                                        controller: searchController,
                                        label: "Search new Member",
                                        onChanged: (value) => context
                                            .read<WorkspaceDetailBloc>()
                                            .add(
                                              WorkspaceDetailEventSearchMember(
                                                search: value,
                                              ),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 7,
                                                  ),
                                              child: Material(
                                                color: AppPropertyColor.white,
                                                elevation: 2,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  onTap: () =>
                                                      listUser.any(
                                                        (element) =>
                                                            element.$1.id ==
                                                            data.id,
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
                                                                  shrinkWrap:
                                                                      true,
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
                                                                        itemCount: EnumProjectRole
                                                                            .values
                                                                            .length,
                                                                        itemBuilder:
                                                                            (
                                                                              context,
                                                                              index,
                                                                            ) => CustomButtonIcon(
                                                                              left: true,
                                                                              icon: Icon(
                                                                                Icons.admin_panel_settings_rounded,
                                                                              ),
                                                                              backgroundColor: AppPropertyColor.white,
                                                                              label: Text(
                                                                                EnumProjectRole.values[index].text,
                                                                              ),
                                                                              onPressed: () {
                                                                                listUser.add(
                                                                                  (
                                                                                    data,
                                                                                    EnumProjectRole.values[index],
                                                                                  ),
                                                                                );
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          data.name,
                                                          style: lv05TextStyle,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Obx(
                                                          () =>
                                                              listUser.any(
                                                                (element) =>
                                                                    element
                                                                        .$1
                                                                        .id ==
                                                                    data.id,
                                                              )
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle_outline_rounded,
                                                                  size:
                                                                      lv2IconSize,
                                                                  color: AppPropertyColor
                                                                      .primary,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .radio_button_unchecked_rounded,
                                                                  size:
                                                                      lv2IconSize,
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

                    BlocSelector<
                      WorkspaceDetailBloc,
                      WorkspaceDetailState,
                      EnumStatusState
                    >(
                      selector: (state) => state is WorkspaceDetailStateLoaded
                          ? state.status
                          : EnumStatusState.none,
                      builder: (context, status) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: status == EnumStatusState.synchronize
                            ? const CustomLoading()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            .read<WorkspaceDetailBloc>()
                                            .add(
                                              WorkspaceDetailEventDeleteProject(),
                                            ),
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
                                        data.$1 == null ? "Add" : "Update",
                                        style: lv1TextStyleWhite,
                                      ),
                                      onPressed: () {
                                        if (!_keyForm.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        if (pickedStart.value.isAfter(
                                          pickedEnd.value,
                                        )) {
                                          return customSnackBar(
                                            context,
                                            "The start date cannot be after the end date!",
                                          );
                                        }
                                        data.$1 != null
                                            ? context
                                                  .read<WorkspaceDetailBloc>()
                                                  .add(
                                                    WorkspaceDetailEventUpdateProject(
                                                      start: pickedStart.value,
                                                      end: pickedEnd.value,
                                                      createdAt: createdAt,
                                                      contributor: listUser
                                                          .toSet(),
                                                      type: typeController.text,
                                                      status:
                                                          projectStatus.value,
                                                    ),
                                                  )
                                            : context
                                                  .read<WorkspaceDetailBloc>()
                                                  .add(
                                                    WorkspaceDetailEventCreateProject(
                                                      name: nameController.text,
                                                      start: pickedStart.value,
                                                      end: pickedEnd.value,
                                                      createdAt: createdAt,
                                                      contributor: listUser
                                                          .toSet(),
                                                      type: typeController.text,
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
              );
            },
          ),
    );
  }
}
