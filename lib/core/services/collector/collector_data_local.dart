import 'package:task_manager/shared/enum/enum_fetch_api.dart';

class CollectDataLocal {
  Future<Map<EnumFetchApiStatus, dynamic>> helperCollectData({
    required Map<EnumFetchApiStatus, dynamic> fetchResult,
    String? title,
  }) async {
    try {
      if (fetchResult.containsKey(EnumFetchApiStatus.failed)) {
        return {
          EnumFetchApiStatus.failed: fetchResult[EnumFetchApiStatus.failed],
        };
      } else if (fetchResult.containsKey(EnumFetchApiStatus.error)) {
        return {
          EnumFetchApiStatus.error: fetchResult[EnumFetchApiStatus.error],
        };
      } else {
        return {
          EnumFetchApiStatus.error:
              "${title != null ? "$title : " : ""}Unknown error, please try again!",
        };
      }
    } catch (e) {
      return {
        EnumFetchApiStatus.error:
            "${title != null ? "$title : " : ""}There is an error: ${e.toString()}",
      };
    }
  }
}
