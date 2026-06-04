class LoginEvent {}

class LoginEventLogin extends LoginEvent {
  final String email;
  final String password;

  LoginEventLogin({required this.email, required this.password});
}

class LoginEventLoading extends LoginEvent {}
