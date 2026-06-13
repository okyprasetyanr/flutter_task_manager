import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

abstract class WorkspaceRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getWorkspace();

  String getCompanyName();
}
