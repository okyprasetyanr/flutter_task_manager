import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class ActivityEvent {}

class ActivityEventWatchActivity extends ActivityEvent {
  final ModelWorkspaceMerge? data;

  ActivityEventWatchActivity({required this.data});
}

class ActivityEventChangeStatus extends ActivityEvent {
  final EnumStatusState status;

  ActivityEventChangeStatus({required this.status});
}

class ActivityEventWatchUser extends ActivityEvent {}
