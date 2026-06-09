import 'package:task_manager/core/services/connection_service/connection_service.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';

class HelperCollectData {
  final ConnectionService connection;

  HelperCollectData({required this.connection});

  Future<Map<EnumFetchApiStatus, dynamic>> helperCollectData({
    required Future<dynamic> Function() remoteFunc,
    required Future<dynamic> Function() localFunc,
  }) async {
    // try {
    if (await connection.isConnected) {
      final remote = await remoteFunc() as Map<String, dynamic>;
      if (remote[EnumFetchApiValue.status.name] ==
          EnumFetchApiStatus.success.name) {
        return {
          EnumFetchApiStatus.success: remote[EnumFetchApiValue.results.name],
        };
      } else if (remote[EnumFetchApiValue.status.name] ==
          EnumFetchApiStatus.failed.name) {
        return {
          EnumFetchApiStatus.failed: remote[EnumFetchApiValue.message.name],
        };
      } else if (remote[EnumFetchApiValue.status.name] ==
          EnumFetchApiStatus.error.name) {
        {
          return {
            EnumFetchApiStatus.error: remote[EnumFetchApiValue.message.name],
          };
        }
      } else {
        return {
          EnumFetchApiStatus.error:
              "Kesalahan tidak diketahui, mohon ulangi kembali!",
        };
      }
    } else {
      return {
        EnumFetchApiStatus.noconnection: "Koneksi tidak tersedia/stabil!",
      };
    }
    // } catch (e) {
    //   return {EnumFetchApiStatus.error: "Terjadi kesalahan: ${e.toString()}"};
    // }
  }
}
