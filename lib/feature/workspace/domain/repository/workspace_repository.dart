import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

abstract class WorkspaceRepository {
  Future<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)> getWorkspace();

  String getCompanyName();

  CollectorMessage createWorkspace({required ModelWorkspace data});
  CollectorMessage updateWorkspace({required ModelWorkspace data});
  CollectorMessage deleteWorkspace({required ModelWorkspace data});
}
