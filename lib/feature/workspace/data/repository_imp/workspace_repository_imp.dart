// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/workspace/data/local/workspace_local.dart';
import 'package:task_manager/feature/workspace/data/remote/workspace_remote.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';

class WorkspaceRepositoryImp implements WorkspaceRepository {
  final WorkspaceRemote remote;
  final WorkspaceLocal local;
  final UserSession userSession;
  final HelperCollectData helper;
  final ModelMessageCollector messageCollector;

  WorkspaceRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });
  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getWorkspace() async {
    final data = await helper.helperCollectData(
      remoteFunc: () async =>
          await remote.getWorkspace(companyId: userSession.getCompanyId()),
      localFunc: () async => {},
    );
    devLog("Log WorkspaceRepositoryImp: data: $data");
    return (data, messageCollector.getMessage(data));
  }

  @override
  String getCompanyName() {
    return userSession.getCompanyName();
  }
}
