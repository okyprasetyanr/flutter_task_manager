import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

abstract class ActivityRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getActivity({
    required String workspaceId,
  });
}
