import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/model/model_user.dart';

abstract class ActivityRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getActivity({
    required String workspaceId,
  });
  List<ModelUser> getUser();
}
