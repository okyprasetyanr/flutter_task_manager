import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/login/domain/enum/enum.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/feature/login/domain/usecase/login_save_account.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_event.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_state.dart';
import 'package:task_manager/shared/helper/common_helper.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repo;
  LoginBloc(this.repo) : super(LoginStateInitial()) {
    on<LoginEventLogin>(_onLogin);
    on<LoginEventLoading>(_onLoading);
  }

  Future<void> _onLogin(LoginEventLogin event, Emitter<LoginState> emit) async {
    add(LoginEventLoading());
    final data = await repo.login(email: event.email, password: event.password);
    if (data.containsKey(EnumLoginStatus.success)) {
      try {
        await LoginSaveAccount(data: data).save();
        emit(LoginStateSuccess());
      } catch (e) {
        devLog("Log LoginBloc: Login: ${e.toString()} : $data");
        emit(
          LoginStateFailed(value: 'Gagal menyimpan akun, silahkan coba lagi!'),
        );
      }
    } else if (data.containsKey(EnumLoginStatus.failed)) {
      emit(LoginStateFailed(value: data[EnumLoginStatus.failed]));
    } else if (data.containsKey(EnumLoginStatus.noconnection)) {
      emit(LoginStateConnection(value: data[EnumLoginStatus.noconnection]));
    }
  }

  FutureOr<void> _onLoading(LoginEventLoading event, Emitter<LoginState> emit) {
    emit(LoginStateLoading());
  }
}
