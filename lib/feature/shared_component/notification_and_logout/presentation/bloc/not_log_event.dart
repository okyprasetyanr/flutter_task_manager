import 'package:task_manager/shared/enum/enum_status_state.dart';

class NotLogEvent {}

class NotLogEventChangeStatus extends NotLogEvent {
  final EnumStatusState status;

  NotLogEventChangeStatus({required this.status});
}

class NotLogEventWatchWorkspace extends NotLogEvent {}

class NotLogEventUpdateIsRead extends NotLogEvent {
  final String notificationId;

  NotLogEventUpdateIsRead({required this.notificationId});
}

class NotLogEventLogout extends NotLogEvent {}
