import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';
import 'package:task_manager/shared/model/model_user.dart';

abstract class HistoryTaskRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getHistoryTask();
  List<ModelUser> getUser();
}
