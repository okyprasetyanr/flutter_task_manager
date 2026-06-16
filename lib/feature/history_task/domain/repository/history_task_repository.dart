import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

abstract class HistoryTaskRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getHistoryTask({
    required String workspaceId,
  });
  List<ModelUser> getUser();
}
