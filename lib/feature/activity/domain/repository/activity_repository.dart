import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';
import 'package:task_manager/shared/model/model_user.dart';

abstract class ActivityRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getActivity({required String workspaceId});
  List<ModelUser> getUser();
}
