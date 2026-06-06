import 'package:task_manager/shared/enum/enum_fetch_api.dart';

class ModelMessageCollector {
  final String? error;
  final String? failed;
  final String? noconnection;

  ModelMessageCollector({this.error, this.failed, this.noconnection});

  ModelMessageCollector getMessage(Map<EnumFetchApiStatus, dynamic> data) {
    return ModelMessageCollector(
      error: data[EnumFetchApiStatus.error],
      failed: data[EnumFetchApiStatus.failed],
      noconnection: data[EnumFetchApiStatus.noconnection],
    );
  }
}
