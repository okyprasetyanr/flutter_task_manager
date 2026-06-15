import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_bloc.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_state.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/widget/notification_list_notification.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/shared/model/model_notification.dart';
import 'package:task_manager/shared/widget/button/custom_button.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      NotificationBloc,
      NotificationState,
      (List<ModelNotification>, EnumStatusState)
    >(
      selector: (state) => state is NotificationStateLoaded
          ? (state.dataNotification, state.status)
          : (const [], EnumStatusState.loading),
      builder: (context, state) {
        return SizedBox(
          height: 40,
          width: 50,
          child: CustomButton(
            padding: false,
            backgroundColor: AppPropertyColor.white,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.notifications,
                    color: AppPropertyColor.secondPrimary,
                    size: 20,
                  ),
                ),
                if (state.$1.any((element) => !element.isRead))
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppPropertyColor.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                if (state.$2 == EnumStatusState.loading)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppPropertyColor.black.withValues(alpha: 0.1),
                      ),
                      child: CircularProgressIndicator(
                        color: AppPropertyColor.primary,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              final bloc = context.read<NotificationBloc>();
              customBottomSheet(
                context: context,
                resetItemForm: null,
                content: (scrollController) {
                  return BlocProvider.value(
                    value: bloc,
                    child:
                        BlocSelector<
                          NotificationBloc,
                          NotificationState,
                          (List<ModelNotification>, EnumStatusState)
                        >(
                          selector: (state) => state is NotificationStateLoaded
                              ? (state.dataNotification, state.status)
                              : (const [], EnumStatusState.loading),
                          builder: (context, state) {
                            return NotificationListNotification(
                              controller: scrollController,
                              data: state.$1,
                              status: state.$2,
                            );
                          },
                        ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
