import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/services/collector/collector_message.dart';
import 'package:task_manager/feature/shared_component/notification/domain/repository/notification_repository.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_event.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/feature/shared_component/notification/domain/model/model_notification.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repo;
  NotificationBloc(this.repo) : super(NotificationStateInitial()) {
    on<NotificationEventWatchWorkspace>(_watchNotification);
    on<NotificationEventChangeStatus>(_onChangeStatus);
    on<NotificationEventUpdateIsRead>(_onUpdateIsRead);
  }

  Future<void> _watchNotification(
    NotificationEventWatchWorkspace event,
    Emitter<NotificationState> emit,
  ) async {
    add(NotificationEventChangeStatus(status: EnumStatusState.synchronize));
    final currentState = state is NotificationStateLoaded
        ? state as NotificationStateLoaded
        : NotificationStateLoaded();
    await emit.forEach<(Map<EnumFetchApiStatus, dynamic>, CollectorMessage)>(
      repo.watchNotification(),
      onData: (data) {
        final Set<dynamic> listData =
            (data.$1[EnumFetchApiStatus.success] as List?)?.toSet() ?? {};

        return currentState.copyWith(
          status: EnumStatusState.none,
          dataNotification: data.$1.containsKey(EnumFetchApiStatus.success)
              ? listData.map((e) => ModelNotification.fromJson(e)).toSet()
              : const {},
          failed: data.$2.failed,
          noconnection: data.$2.noconnection,
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
    NotificationEventChangeStatus event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      (state is NotificationStateLoaded
              ? state as NotificationStateLoaded
              : NotificationStateLoaded())
          .copyWith(status: event.status),
    );
  }

  Future<void> _onUpdateIsRead(
    NotificationEventUpdateIsRead event,
    Emitter<NotificationState> emit,
  ) async {
    add(NotificationEventChangeStatus(status: EnumStatusState.synchronize));
    final data = await repo.updateIsRead(notificationId: event.notificationId);
    devLog("state as NotificationStateLoaded");
    if (data != null) {
      emit(
        (state as NotificationStateLoaded).copyWith(
          error: data.error,
          failed: data.failed,
          status: EnumStatusState.none,
        ),
      );
    }
  }
}
