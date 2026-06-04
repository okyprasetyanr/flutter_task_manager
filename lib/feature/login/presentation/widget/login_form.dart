import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_state.dart';
import 'package:task_manager/shared/widget/text_field/custom_text_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> keyform;
  final TextEditingController email;
  final TextEditingController password;
  final ValueNotifier<bool> visiblepass;
  const LoginForm({
    super.key,
    required this.keyform,
    required this.email,
    required this.password,
    required this.visiblepass,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginStateLoading) {
          return Center(child: LinearProgressIndicator());
        } else {
          return Form(
            key: keyform,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: email,
                  inputType: TextInputType.emailAddress,
                  label: "E-mail",
                  validator: (value) =>
                      value!.isEmpty ? "E-mail tidak boleh Kosong!" : null,
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: visiblepass,
                  builder: (context, value, child) => CustomTextField(
                    controller: password,
                    inputType: TextInputType.visiblePassword,
                    label: "Password",
                    validator: (value) =>
                        value!.isEmpty ? "Password wajib diisi!" : null,
                    password: true,
                    visiblepass: value,
                    changeVisiblePass: (value) => visiblepass.value = value,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
