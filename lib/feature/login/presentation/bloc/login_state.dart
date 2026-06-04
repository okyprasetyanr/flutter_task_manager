// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginState {}

class LoginStateSuccess extends LoginState {}

class LoginStateInitial extends LoginState {}

class LoginStateFailed extends LoginState {
  String value;
  LoginStateFailed({required this.value});
}

class LoginStateConnection extends LoginState {
  String value;
  LoginStateConnection({required this.value});
}

class LoginStateLoading extends LoginState {}
