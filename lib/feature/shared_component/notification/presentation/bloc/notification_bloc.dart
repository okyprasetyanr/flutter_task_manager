import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/shared_component/notification/domain/repository/notification_repository.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_event.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_state.dart';
import 'package:task_manager/shared/enum/enum_fetch_api.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_notification.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repo;
  NotificationBloc(this.repo) : super(NotificationStateInitial()) {
    on<NotificationEventgetData>(_onGetData);
    on<NotificationEventChangeStatus>(_onChangeStatus);
  }

  Future<void> _onGetData(
    NotificationEventgetData event,
    Emitter<NotificationState> emit,
  ) async {
    add(NotificationEventChangeStatus(status: EnumStatusState.loading));
    final currentState = state is NotificationStateLoaded
        ? state as NotificationStateLoaded
        : NotificationStateLoaded();

    final data = await repo.getNotification();
    emit(
      currentState.copyWith(
        dataNotification: data.$1.containsKey(EnumFetchApiStatus.success)
            ? (data.$1[EnumFetchApiStatus.success] as List)
                  .map((e) => ModelNotification.fromJson(e))
                  .toList()
            : const [],
        error: data.$2.error,
        failed: data.$2.failed,
        noconnection: data.$2.noconnection,
        status: EnumStatusState.none,
      ),
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
}
