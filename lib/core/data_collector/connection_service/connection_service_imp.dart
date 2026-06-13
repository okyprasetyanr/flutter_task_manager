import 'dart:io';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:task_manager/core/services/connection_service/connection_service.dart';

class ConnectionServiceImpl implements ConnectionService {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');

      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectionChanged {
    return InternetConnection().onStatusChange.map(
      (event) => event == InternetStatus.connected,
    );
  }
}
