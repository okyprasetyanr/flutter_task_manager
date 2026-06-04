// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/services/connection_service.dart';
import 'package:task_manager/feature/login/data/remote/login_remote.dart';
import 'package:task_manager/feature/login/domain/enum/enum.dart';
import 'package:task_manager/feature/login/domain/repository/login_repository.dart';
import 'package:task_manager/shared/enum/enum_status_fetch.dart';

class LoginRepositoryImp implements LoginRepository {
  final ConnectionService connection;
  final LoginRemote remote;

  LoginRepositoryImp({required this.connection, required this.remote});

  @override
  Future<Map<EnumLoginStatus, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (await connection.isConnected) {
        final data = await remote.login(email: email, password: password);
        if (data.containsKey(EnumStatusFetch.success.name)) {
          return {EnumLoginStatus.success: data[EnumStatusFetch.success.name]};
        } else {
          return {EnumLoginStatus.failed: data[EnumStatusFetch.failed.name]};
        }
      } else {
        return {EnumLoginStatus.noconnection: "Koneksi tidak tersedia!"};
      }
    } catch (e) {
      return {EnumLoginStatus.failed: "Terjadi kesalahan: ${e.toString()}"};
    }
  }
}
