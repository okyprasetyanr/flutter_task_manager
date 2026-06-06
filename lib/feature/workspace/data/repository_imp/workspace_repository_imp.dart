// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/workspace/data/local/workspace_local.dart';
import 'package:task_manager/feature/workspace/data/remote/workspace_remote.dart';
import 'package:task_manager/feature/workspace/domain/repository/workspace_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';

class WorkspaceRepositoryImp implements WorkspaceRepository {
  final WorkspaceRemote remote;
  final WorkspaceLocal local;
  final UserSession userSession;
  final HelperCollectData helper;

  WorkspaceRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
  });
  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getWorkspace() async {
    final data = await helper.helperCollectData(
      remoteFunc: () async =>
          await remote.getWorkspace(idCompany: userSession.getCompanyId()),
      localFunc: () async => {},
    );
    final messageCollector = ModelMessageCollector(
      error: data[EnumFetchApiStatus.error],
      failed: data[EnumFetchApiStatus.failed],
      noconnection: data[EnumFetchApiStatus.noconnection],
    );
    return (data, messageCollector);
  }

  @override
  String getCompanyName() {
    return userSession.getCompanyName();
  }
}
