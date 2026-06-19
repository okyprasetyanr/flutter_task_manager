import 'package:task_manager/core/services/connection_service/connection_service.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';

class CollectData {
  final ConnectionService connection;

  CollectData({required this.connection});

  Future<Map<EnumFetchApiStatus, dynamic>> collectDataRemote({
    required Future<dynamic> Function() remoteFunc,
    required Future<dynamic> Function({required dynamic dataToCache}) localFunc,
    String? pageName,
  }) async {
    try {
      if (await connection.isConnected) {
        final remote = await remoteFunc() as Map<String, dynamic>;
        if (remote[EnumFetchApiValue.status.name] ==
            EnumFetchApiStatus.success.name) {
          final result = remote[EnumFetchApiValue.results.name];
          await localFunc(dataToCache: result);
          return {EnumFetchApiStatus.success: result};
        } else if (remote[EnumFetchApiValue.status.name] ==
            EnumFetchApiStatus.failed.name) {
          return {
            EnumFetchApiStatus.failed:
                "$pageName Server: ${remote[EnumFetchApiValue.message.name]}",
          };
        } else if (remote[EnumFetchApiValue.status.name] ==
            EnumFetchApiStatus.error.name) {
          return {
            EnumFetchApiStatus.error:
                "$pageName Server: ${remote[EnumFetchApiValue.message.name]}",
          };
        } else {
          return {
            EnumFetchApiStatus.error:
                "$pageName Server Unknown error, please try again!",
          };
        }
      }
      return {
        EnumFetchApiStatus.noconnection:
            "$pageName Server: Connection is unavailable/unstable!",
      };
    } catch (e) {
      return {
        EnumFetchApiStatus.error:
            "$pageName Server: There is an error: ${e.toString()}",
      };
    }
  }

  Map<EnumFetchApiStatus, dynamic> collectDataLocal({
    required Map<String, dynamic> fetchResult,
    String? pageName,
  }) {
    try {
      if (fetchResult[EnumFetchApiValue.status.name] ==
          EnumFetchApiStatus.success.name) {
        return {
          EnumFetchApiStatus.success:
              fetchResult[EnumFetchApiValue.results.name],
        };
      } else if (fetchResult[EnumFetchApiValue.status.name] ==
          EnumFetchApiStatus.failed.name) {
        return {
          EnumFetchApiStatus.failed:
              "$pageName Local: ${fetchResult[EnumFetchApiValue.message.name]}",
        };
      } else if (fetchResult[EnumFetchApiValue.status.name] ==
          EnumFetchApiStatus.error.name) {
        return {
          EnumFetchApiStatus.error:
              "$pageName Local: ${fetchResult[EnumFetchApiValue.message.name]}",
        };
      } else {
        return {
          EnumFetchApiStatus.error:
              "$pageName Local: Unknown error, please try again!",
        };
      }
    } catch (e) {
      return {
        EnumFetchApiStatus.error:
            "$pageName Local: There is an error: ${e.toString()}",
      };
    }
  }
}
