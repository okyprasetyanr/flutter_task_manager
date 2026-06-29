import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/core/routes/routes_enum.dart';
import 'package:task_manager/core/routes/routes_navigator.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/bloc/not_log_bloc.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/bloc/not_log_event.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/bloc/not_log_state.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/widget/not_log_list_notification.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/style/text_size.dart';

class NotLogWidget extends StatefulWidget {
  const NotLogWidget({super.key});

  @override
  State<NotLogWidget> createState() => _NotLogWidgetState();
}

class _NotLogWidgetState extends State<NotLogWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is NotLogStateLogout) {
          RoutesNavigator(
            context: context,
            routeName: RoutesEnum.login,
            replace: true,
            arguments: null,
          );
        }
      },
      child: Row(
        children: [
          BlocSelector<
            NotLogBloc,
            NotLogState,
            (Set<ModelNotification>, EnumStatusState)
          >(
            selector: (state) => state is NotLogStateLoaded
                ? (state.dataNotification, state.status)
                : (const {}, EnumStatusState.loading),
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
                              color: AppPropertyColor.black.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            child: CircularProgressIndicator(
                              color: AppPropertyColor.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    final bloc = context.read<NotLogBloc>();
                    customBottomSheet(
                      context: context,
                      resetItemForm: null,
                      content: (scrollController) {
                        return BlocProvider.value(
                          value: bloc,
                          child:
                              BlocSelector<
                                NotLogBloc,
                                NotLogState,
                                (Set<ModelNotification>, EnumStatusState)
                              >(
                                selector: (state) => state is NotLogStateLoaded
                                    ? (state.dataNotification, state.status)
                                    : (const {}, EnumStatusState.loading),
                                builder: (context, state) {
                                  return NotLogListNotification(
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
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: CustomButton(
              padding: false,
              backgroundColor: AppPropertyColor.white,
              child: Icon(
                Icons.power_settings_new,
                color: AppPropertyColor.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlocSelector(
                      selector: (state) => state is NotLogStateLoaded
                          ? state.status
                          : EnumStatusState.none,
                      builder: (context, state) =>
                          state == EnumStatusState.logout
                          ? CustomLoading()
                          : AlertDialog(
                              title: Text("Logout", style: titleTextStyle),
                              content: Text(
                                "Are you sure to Logout?",
                                style: lv05TextStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("No", style: lv1TextStyle),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<NotLogBloc>().add(
                                      NotLogEventLogout(),
                                    );
                                  },
                                  child: Text("Yes", style: lv1TextStyleRed),
                                ),
                              ],
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
