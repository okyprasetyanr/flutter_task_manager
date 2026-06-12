import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_state.dart';
import 'package:task_manager/feature/login/presentation/widget/login_button.dart';
import 'package:task_manager/feature/login/presentation/widget/login_form.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_bloc.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_event.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/snackbar/custom_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final _key = GlobalKey<FormState>();
  final visiblepass = ValueNotifier<bool>(false);

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    visiblepass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(uiPage: uiPage());
  }

  Widget uiPage() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginStateSuccess) {
          context.read<NotificationBloc>().add(NotificationEventgetData());
          customSnackBar(context, "Login Berhasil");
          RoutesNavigator(
            context: context,
            routeName: RoutesEnum.workspace,
            replace: true,
            arguments: null,
          ).navigate();
        } else if (state is LoginStateFailed) {
          customSnackBar(context, state.value);
        } else if (state is LoginStateConnection) {
          customSnackBar(context, state.value);
        } else if (state is LoginStateError) {
          customSnackBar(context, state.value);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Login", style: titleTextStyle),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 30),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 130,
                    child: LoginForm(
                      keyform: _key,
                      email: email,
                      password: password,
                      visiblepass: visiblepass,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LoginButton(keyform: _key, email: email, password: password),
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              "Ringkas App.\nCreated by Oky Prasetya Nur Rokhym!",
              style: lv05TextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
