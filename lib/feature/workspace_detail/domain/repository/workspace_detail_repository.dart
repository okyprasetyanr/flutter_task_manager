import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/model/model_user.dart';

abstract class WorkspaceDetailRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  getWorkspaceDetai({required String workspaceId, required String companyId});
  List<ModelUser> getUser();
}
