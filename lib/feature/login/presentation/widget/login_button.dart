import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_event.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/snackbar/custom_snackbar.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomButton(
            backgroundColor: AppPropertyColor.primary,
            onPressed: () {
              if (keyform.currentState!.validate()) {
                customSnackBar(context, "Feature not available!", top: true);
              }
            },
            child: Text("Create Account", style: lv05TextStyleWhite),
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
            child: Text("Login", style: lv05TextStyleWhite),
          ),
        ),
      ],
    );
  }
}
