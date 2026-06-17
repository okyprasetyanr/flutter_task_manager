import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/shared_component/notification/domain/model/model_notification.dart';

class NotificationState {}

class NotificationStateInitial extends NotificationState {}

class NotificationStateLoaded extends NotificationState with EquatableMixin {
  final Set<ModelNotification> dataNotification;
  final EnumStatusState status;
  final String? error;
  final String? noconnection;
  final String? failed;

  NotificationStateLoaded({
    this.dataNotification = const {},
    this.status = EnumStatusState.none,
    this.error,
    this.noconnection,
    this.failed,
  });

  NotificationStateLoaded copyWith({
    Set<ModelNotification>? dataNotification,
    EnumStatusState? status,
    String? error,
    String? failed,
    String? noconnection,
  }) {
    return NotificationStateLoaded(
      dataNotification: dataNotification ?? this.dataNotification,
      error: error ?? this.error,
      failed: failed ?? this.failed,
      noconnection: noconnection ?? this.noconnection,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    dataNotification,
    status,
    error,
    noconnection,
    failed,
  ];
}
