import 'package:task_manager/shared/enum/enum_fetch_api.dart';

class CollectorMessage {
  final String? error;
  final String? failed;
  final String? noconnection;

  CollectorMessage({this.error, this.failed, this.noconnection});

  CollectorMessage getMessage(Map<EnumFetchApiStatus, dynamic> data) {
    return CollectorMessage(
      error: data[EnumFetchApiStatus.error],
      failed: data[EnumFetchApiStatus.failed],
      noconnection: data[EnumFetchApiStatus.noconnection],
    );
  }
}
