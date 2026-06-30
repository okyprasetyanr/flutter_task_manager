import 'package:task_manager/core/services/local_database/local_database.dart';

class LoginLocal {
  final LocalDatabase localDatabase;

  LoginLocal({required this.localDatabase});

  Future<void> clearTable() async {
    await localDatabase.clearAll();
  }
}
