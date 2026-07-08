import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_event.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/common_widget/button/custom_button_icon.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text_field/custom_text_field.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WorkspaceBotshetContentdMember extends StatefulWidget {
  const WorkspaceBotshetContentdMember({super.key});

  @override
  State<WorkspaceBotshetContentdMember> createState() =>
      _WorkspaceBotshetContentdMemberState();
}

class _WorkspaceBotshetContentdMemberState
    extends State<WorkspaceBotshetContentdMember> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  bool _initialized = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
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
      child: BlocSelector<WorkspaceBloc, WorkspaceState, ModelUser?>(
        selector: (state) =>
            state is WorkspaceStateLoaded ? state.selectedMember : null,
        builder: (context, state) {
          if (state != null && !_initialized) {
            emailController.text = state.email;
            nameController.text = state.name;
            _initialized = true;
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Form Member", style: titleTextStyle),
                const SizedBox(height: 10),
                Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      CustomTextField(
                        validator: (value) =>
                            value!.isEmpty ? "E-mail is required!" : null,
                        inputType: TextInputType.emailAddress,
                        label: "E-mail",
                        controller: emailController,
                        prefix: Icon(
                          Icons.person,
                          color: AppPropertyColor.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        validator: (value) => value!.isEmpty
                            ? "Member Name cannot be Empty!"
                            : null,
                        controller: nameController,
                        prefix: Icon(
                          Icons.email_rounded,
                          color: AppPropertyColor.black,
                        ),
                        label: "Name",
                      ),
                    ],
                  ),
                ),
                Spacer(),
                BlocSelector<WorkspaceBloc, WorkspaceState, EnumStatusState>(
                  selector: (state) => state is WorkspaceStateLoaded
                      ? state.status
                      : EnumStatusState.none,
                  builder: (context, status) =>
                      status == EnumStatusState.synchronize
                      ? const CustomLoading()
                      : Row(
                          children: [
                            if (state != null)
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
                                      .add(WorkspaceEventDeleteMember()),
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
                                  state != null ? "Update" : "Add",
                                  style: lv1TextStyleWhite,
                                ),
                                padding: true,
                                onPressed: () {
                                  if (!_keyForm.currentState!.validate()) {
                                    return;
                                  }
                                  state != null
                                      ? context.read<WorkspaceBloc>().add(
                                          WorkspaceEventUpdateMember(
                                            email: emailController.text,
                                            name: nameController.text,
                                          ),
                                        )
                                      : context.read<WorkspaceBloc>().add(
                                          WorkspaceEventCreateMember(
                                            name: nameController.text,
                                            email: emailController.text,
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
