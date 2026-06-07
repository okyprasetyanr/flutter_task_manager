import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';

abstract class ProjectDetailRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getProjectDetail({required projectId});
}
