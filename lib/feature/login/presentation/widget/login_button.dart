import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_event.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_state.dart';
import 'package:task_manager/shared/widget/button/custom_button.dart';
import 'package:task_manager/shared/widget/snackbar/custom_snackbar.dart';
import 'package:task_manager/shared/style/text_size.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> keyform;
  final TextEditingController email;
  final TextEditingController password;
  const LoginButton({
    super.key,
    required this.keyform,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginStateFailed) {
          customSnackBar(context, state.value);
        } else if (state is LoginStateSuccess) {
          customSnackBar(context, "Login Berhasil");
        } else if (state is LoginStateConnection) {
          customSnackBar(context, state.value);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomButton(
              backgroundColor: AppPropertyColor.primary,
              onPressed: () {
                if (keyform.currentState!.validate()) {
                  customSnackBar(context, "Fitur belum tersedia!", top: true);
                }
              },
              child: Text("Daftar", style: lv05TextStyleWhite),
            ),
          ),
          Expanded(
            child: CustomButton(
              backgroundColor: AppPropertyColor.primary,
              onPressed: () {
                if (keyform.currentState!.validate()) {
                  context.read<LoginBloc>().add(
                    LoginEventLogin(email: email.text, password: password.text),
                  );
                }
              },
              child: Text("Masuk", style: lv05TextStyleWhite),
            ),
          ),
        ],
      ),
    );
  }
}
