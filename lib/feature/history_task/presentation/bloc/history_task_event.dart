// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/workspace/domain/model/model_workspace_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class HistoryTaskEvent {}

class HistoryTaskEventWatchHistory extends HistoryTaskEvent {
  final ModelWorkspaceMerge? data;

  HistoryTaskEventWatchHistory({this.data});
}

class HistoryTaskEventChangeStatus extends HistoryTaskEvent {
  final EnumStatusState status;

  HistoryTaskEventChangeStatus({required this.status});
}

class HistoryTaskEventWatchUser extends HistoryTaskEvent {}
