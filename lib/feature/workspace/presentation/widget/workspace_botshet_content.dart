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
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
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
  final listUser = <(ModelUser, EnumWorkspaceRole)>{}.obs;

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
      child: BlocSelector<WorkspaceBloc, WorkspaceState, ModelWorkspaceMerge?>(
        selector: (state) =>
            state is WorkspaceStateLoaded ? state.selectedWorkspace : null,
        builder: (context, data) {
          if (!_initialized && data != null) {
            _initialized = true;
            nameController.text = data.dataWorkspace.name;
            descriptionController.text = data.dataWorkspace.description;
            listUser.addAll(
              data.dataWorkspaceMember.map(
                (e) => (e, EnumWorkspaceRole.member),
              ),
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
                                  itemBuilder: (context, index) {
                                    final data = listUser.elementAt(index).$1;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        CustomButton(
                                          backgroundColor:
                                              AppPropertyColor.white,
                                          onPressed: () => listUser.removeWhere(
                                            (element) =>
                                                element.$1.id == data.id,
                                          ),
                                          child: Icon(
                                            Icons.close_rounded,
                                            color: AppPropertyColor.red,
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
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                            BlocSelector<
                              WorkspaceBloc,
                              WorkspaceState,
                              Set<ModelUser>
                            >(
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
                                          WorkspaceEventSearchMember(
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
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Obx(
                                              () => CustomButton(
                                                backgroundColor:
                                                    AppPropertyColor.white,
                                                onPressed: () =>
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
                                                    : listUser.add((
                                                        data,
                                                        EnumWorkspaceRole
                                                            .member,
                                                      )),
                                                child:
                                                    listUser.any(
                                                      (element) =>
                                                          element.$1.id ==
                                                          data.id,
                                                    )
                                                    ? Icon(
                                                        Icons
                                                            .check_circle_outline_rounded,
                                                        size: lv2IconSize,
                                                        color: AppPropertyColor
                                                            .primary,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .radio_button_unchecked_rounded,
                                                        size: lv2IconSize,
                                                      ),
                                              ),
                                            ),
                                          ],
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
                      ? const CustomLoading()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (data != null)
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
                                  data != null ? "Update" : "Add",
                                  style: lv1TextStyleWhite,
                                ),
                                padding: true,
                                onPressed: () {
                                  if (!_keyForm.currentState!.validate()) {
                                    return;
                                  }
                                  data != null
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
                                  nameController.clear();
                                  descriptionController.clear();
                                  searchController.clear();
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
