import 'package:task_manager/core/services/connection_service/connection_service.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';

class CollectDataRemote {
  final ConnectionService connection;

  CollectDataRemote({required this.connection});

  Future<Map<EnumFetchApiStatus, dynamic>> helperCollectData({
    required Future<dynamic> Function() remoteFunc,
    required Future<dynamic> Function({dynamic dataToCache}) localFunc,
    String? title,
  }) async {
    try {
      if (await connection.isConnected) {
        final remote = await remoteFunc() as Map<String, dynamic>;

        if (remote[EnumFetchApiValue.status.name] ==
            EnumFetchApiStatus.success.name) {
          final remoteResults = remote[EnumFetchApiValue.results.name];
          await localFunc(dataToCache: remoteResults);

          return {EnumFetchApiStatus.success: remoteResults};
        } else if (remote[EnumFetchApiValue.status.name] ==
            EnumFetchApiStatus.failed.name) {
          return {
            EnumFetchApiStatus.failed: remote[EnumFetchApiValue.message.name],
          };
        } else if (remote[EnumFetchApiValue.status.name] ==
            EnumFetchApiStatus.error.name) {
          return {
            EnumFetchApiStatus.error: remote[EnumFetchApiValue.message.name],
          };
        } else {
          return {
            EnumFetchApiStatus.error:
                "${title != null ? "$title : " : ""}Unknown error, please try again!",
          };
        }
      }
      return {
        EnumFetchApiStatus.noconnection:
            "${title != null ? "$title : " : null}Connection is unavailable/unstable!",
      };
    } catch (e) {
      return {
        EnumFetchApiStatus.error:
            "${title != null ? "$title : " : ""}There is an error: ${e.toString()}",
      };
    }
  }
}
