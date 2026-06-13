import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

abstract class ProjectDetailRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  getProjectDetail({required String projectId});
}
