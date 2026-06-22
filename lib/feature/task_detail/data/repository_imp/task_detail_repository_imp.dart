// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/cache/user_cache.dart';
import 'package:task_manager/core/services/remote_service/remote_service.dart';
import 'package:task_manager/core/user_session/user_session.dart';
import 'package:task_manager/feature/task_detail/data/local/task_detail_local.dart';
import 'package:task_manager/feature/task_detail/domain/repository/task_detail_repository.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_data.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';

class TaskDetailRepositoryImp implements TaskDetailRepository {
  final RemoteServices remote;
  final TaskDetailLocal local;
  final UserSession userSession;
  final CollectData helper;
  final CollectorMessage messageCollector;
  final UserCache userCache;
  TaskDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.userSession,
    required this.helper,
    required this.messageCollector,
    required this.userCache,
  });
  @override
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getComment({
    required String taskId,
  }) async {
    final data = await helper.collectDataRemote(
      remoteFunc: () async => remote.taskDetailRemote.getComment(
        companyId: userSession.getCompanyId(),
        taskId: taskId,
      ),
      localFunc: ({required dataToCache}) async => {},
    );

    return (data, messageCollector.getMessage(data));
  }
}
