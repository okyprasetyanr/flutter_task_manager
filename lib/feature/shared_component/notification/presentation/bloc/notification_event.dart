import 'package:task_manager/shared/enum/enum_status_state.dart';

class NotificationEvent {}

class NotificationEventgetData extends NotificationEvent {}

class NotificationEventChangeStatus extends NotificationEvent {
  final EnumStatusState status;

  NotificationEventChangeStatus({required this.status});
}
