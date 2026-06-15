import 'package:task_manager/shared/enum/enum_status_state.dart';

class NotificationEvent {}

class NotificationEventChangeStatus extends NotificationEvent {
  final EnumStatusState status;

  NotificationEventChangeStatus({required this.status});
}

class NotificationEventWatchWorkspace extends NotificationEvent {}

class NotificationEventUpdateIsRead extends NotificationEvent {
  final String notificationId;

  NotificationEventUpdateIsRead({required this.notificationId});
}
