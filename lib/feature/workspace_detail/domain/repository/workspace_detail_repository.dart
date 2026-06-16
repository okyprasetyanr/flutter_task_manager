import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

abstract class WorkspaceDetailRepository {
  List<ModelUser> getUser();
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchProject({
    required String workspaceId,
  });
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  watchProjectMember({required List<String> projectIds});
}
