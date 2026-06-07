// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/workspace_detail/data/local/workspace_detail_local.dart';
import 'package:task_manager/feature/workspace_detail/data/remote/workspace_detail_remote.dart';
import 'package:task_manager/feature/workspace_detail/domain/repository/workspace_detail_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/helper/helper_collect_data/helper_collect_data.dart';
import 'package:task_manager/shared/model/model_message_collector.dart';

class WorkspaceDetailRepositoryImp implements WorkspaceDetailRepository {
  final WorkspaceDetailRemote remote;
  final WorkspaceDetailLocal local;
  final UserSession userSession;
  final HelperCollectData helper;
  final ModelMessageCollector messageCollector;

  WorkspaceDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
  });

  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, ModelMessageCollector)>
  getWorkspaceDetai({
    required String workspaceId,
    required String companyId,
  }) async {
    final data = await helper.helperCollectData(
      remoteFunc: () async => await remote.getWorkspaceDetail(
        workspaceId: workspaceId,
        companyId: companyId,
      ),
      localFunc: () async => {},
    );

    return (data, messageCollector.getMessage(data));
  }
}
