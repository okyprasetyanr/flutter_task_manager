import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/feature/login/domain/usecase/login_save_account.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_event.dart';
import 'package:task_manager/feature/login/presentation/bloc/login_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repo;
  LoginBloc(this.repo) : super(LoginStateInitial()) {
    on<LoginEventLogin>(_onLogin);
    on<LoginEventLoading>(_onLoading);
  }

  Future<void> _onLogin(LoginEventLogin event, Emitter<LoginState> emit) async {
    add(LoginEventLoading());
    final data = await repo.login(email: event.email, password: event.password);
    if (data.containsKey(EnumFetchApiStatus.success)) {
      try {
        await LoginSaveAccount(data: data[EnumFetchApiStatus.success]).save();
        emit(LoginStateSuccess());
      } catch (e) {
        devLog(
          "Log LoginBloc: Login: ${e.toString()} : ${data[EnumFetchApiStatus.success]}",
        );
        emit(
          LoginStateFailed(value: 'Gagal menyimpan akun, silahkan coba lagi!'),
        );
      }
    } else if (data.containsKey(EnumFetchApiStatus.failed)) {
      emit(LoginStateFailed(value: data[EnumFetchApiStatus.failed]));
    } else if (data.containsKey(EnumFetchApiStatus.noconnection)) {
      emit(LoginStateConnection(value: data[EnumFetchApiStatus.noconnection]));
    } else if (data.containsKey(EnumFetchApiStatus.error)) {
      emit(LoginStateError(value: data[EnumFetchApiStatus.error]));
    }
  }

  FutureOr<void> _onLoading(LoginEventLoading event, Emitter<LoginState> emit) {
    emit(LoginStateLoading());
  }
}
