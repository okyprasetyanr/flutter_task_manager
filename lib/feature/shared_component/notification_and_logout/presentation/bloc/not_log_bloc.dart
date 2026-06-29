import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/repository/not_log_repository.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/bloc/not_log_event.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/bloc/not_log_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';

class NotLogBloc extends Bloc<NotLogEvent, NotLogState> {
  final NotLogRepository repo;
  NotLogBloc(this.repo) : super(NotLogStateInitial()) {
    on<NotLogEventWatchWorkspace>(_watchNotification);
    on<NotLogEventChangeStatus>(_onChangeStatus);
    on<NotLogEventUpdateIsRead>(_onUpdateIsRead);
    on<NotLogEventLogout>(_onLogout);
  }

  Future<void> _watchNotification(
    NotLogEventWatchWorkspace event,
    Emitter<NotLogState> emit,
  ) async {
    add(NotLogEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state is NotLogStateLoaded
        ? state as NotLogStateLoaded
        : NotLogStateLoaded();
    await emit.forEach<Set<ModelNotification>>(
      repo.getNotification(),
      onData: (data) {
        devLog("Log NotificationBloc: watchNotification: $data");
        return currentState.copyWith(
          status: EnumStatusState.none,
          dataNotification: data,
        );
      },
      onError: (error, stackTrace) {
        return currentState.copyWith(
          status: EnumStatusState.none,
          error: error.toString(),
        );
      },
    );
  }

  FutureOr<void> _onChangeStatus(
    NotLogEventChangeStatus event,
    Emitter<NotLogState> emit,
  ) {
    emit(
      (state is NotLogStateLoaded
              ? state as NotLogStateLoaded
              : NotLogStateLoaded())
          .copyWith(status: event.status),
    );
  }

  Future<void> _onUpdateIsRead(
    NotLogEventUpdateIsRead event,
    Emitter<NotLogState> emit,
  ) async {
    add(NotLogEventChangeStatus(status: EnumStatusState.synchronize));
    final data = await repo.updateIsRead(notificationId: event.notificationId);
    devLog("state as NotificationStateLoaded");
    if (data != null) {
      emit(
        (state as NotLogStateLoaded).copyWith(
          error: data.error,
          failed: data.failed,
          status: EnumStatusState.none,
        ),
      );
    }
  }

  Future<void> _onLogout(
    NotLogEventLogout event,
    Emitter<NotLogState> emit,
  ) async {
    add(NotLogEventChangeStatus(status: EnumStatusState.logout));
    await repo.logout();
    emit(NotLogStateLogout());
  }
}
