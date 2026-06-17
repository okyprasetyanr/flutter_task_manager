import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

abstract class TaskDetailRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getComment({
    required String taskId,
  });

  Set<ModelUser> getUser();
}
