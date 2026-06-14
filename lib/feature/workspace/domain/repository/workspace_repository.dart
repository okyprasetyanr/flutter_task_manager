import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/workspace/domain/model/model_workspace.dart';

abstract class WorkspaceRepository {
  Stream<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> watchWorkspace();

  String getCompanyName();

  Future<CollectorMessage?> createWorkspace({required ModelWorkspace data});
  Future<CollectorMessage?> updateWorkspace({
    required ModelWorkspace original,
    required ModelWorkspace edited,
  });
  Future<CollectorMessage?> deleteWorkspace({required String workspaceId});
}
