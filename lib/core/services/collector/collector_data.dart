import 'package:task_manager/core/services/connection_service/connection_service.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';

class CollectData {
  final ConnectionService connection;

  CollectData({required this.connection});

  Future<Map<EnumFetchApiStatus, dynamic>> helperCollectData({
    required dynamic Function() remoteFunc,
    required dynamic Function() localFunc,
    String? title,
  }) async {
    try {
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
                "${title != null ? "$title : " : null}Unknown error, please try again!",
          };
        }
      } else {
        return {
          EnumFetchApiStatus.noconnection:
              "${title != null ? "$title : " : null}Connection is unavailable/unstable!",
        };
      }
    } catch (e) {
      return {
        EnumFetchApiStatus.error:
            "${title != null ? "$title : " : null}There is an error: ${e.toString()}",
      };
    }
  }
}
