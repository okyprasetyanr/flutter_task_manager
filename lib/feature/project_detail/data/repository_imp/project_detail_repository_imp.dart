import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/project_detail/data/local/project_detail_local.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data_remote.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

class ProjectDetailRepositoryImp implements ProjectDetailRepository {
  final RemoteService remote;
  final ProjectDetailLocal local;
  final UserSession userSession;
  final CollectDataRemote helper;
  final CollectorMessage messageCollector;

  ProjectDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });
  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>
  getProjectDetail({required String projectId}) async {
    final data = await helper.helperCollectData(
      remoteFunc: () async => await remote.projectDetailRemote.getProjectDetail(
        projectId: projectId,
        companyId: userSession.getCompanyId(),
      ),
      localFunc: ({dataToCache}) async => {},
    );
    devLog("Log ProjectDetailRepositoryImp: data: $data");
    return (data, messageCollector.getMessage(data));
  }
}
