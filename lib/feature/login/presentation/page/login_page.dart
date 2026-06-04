import 'package:flutter/material.dart';
import 'package:task_manager/base_layout/base_layout.dart';
import 'package:task_manager/feature/login/presentation/widget/login_button.dart';
import 'package:task_manager/feature/login/presentation/widget/login_form.dart';
import 'package:task_manager/shared/style/text_size.dart';

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
    return Column(
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
    );
  }
}
