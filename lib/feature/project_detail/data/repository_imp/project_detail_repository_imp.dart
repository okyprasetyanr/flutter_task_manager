import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/project_detail/data/local/project_detail_local.dart';
import 'package:task_manager/feature/project_detail/data/remote/project_detail_remote.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';

class ProjectDetailRepositoryImp implements ProjectDetailRepository {
  final ProjectDetailRemote remote;
  final ProjectDetailLocal local;
  final UserSession userSession;
  final HelperCollectData helper;
  final ModelMessageCollector messageCollector;

  ProjectDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });
  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getProjectDetail({required projectId}) async {
    final data = await helper.helperCollectData(
      remoteFunc: () async => await remote.getProjectDetail(
        projectId: projectId,
        companyId: userSession.getCompanyId(),
      ),
      localFunc: () async => {},
    );
    return (data, messageCollector.getMessage(data));
  }
}
