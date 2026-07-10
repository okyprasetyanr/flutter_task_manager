import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:task_manager/feature/workspace/presentation/bloc/workspace_state.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WorkspaceNotification extends StatelessWidget {
  const WorkspaceNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child:
            BlocSelector<WorkspaceBloc, WorkspaceState, Set<ModelNotification>>(
              selector: (state) =>
                  state is WorkspaceStateLoaded ? state.dataNotification : {},
              builder: (context, state) {
                final newNotification = state.where(
                  (element) => !element.isRead,
                );
                final lastNotification = state.reduce((value, element) {
                  DateTime currentStyle = value.createdAt;
                  DateTime nextStyle = element.createdAt;
                  return currentStyle.isAfter(nextStyle) ? value : element;
                });
                if (state.isEmpty) {
                  return Text(
                    "You don't have any notifications.",
                    style: lv1TextStyleWhite,
                  );
                }
                if (state.isNotEmpty &&
                    state.any((element) => !element.isRead)) {
                  return Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "You have ",
                              style: lv1TextStyleWhite,
                            ),
                            TextSpan(
                              text: newNotification.length.toString(),
                              style: lv1TextStyleWhiteBold,
                            ),
                            TextSpan(
                              text: " unread Notifications!",
                              style: lv1TextStyleWhite,
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Your latest notification is about: ",
                          style: lv1TextStyleWhite,
                          children: [
                            TextSpan(
                              text: newNotification.first.title,
                              style: lv1TextStyleWhiteBold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "No new notifications.\nThe ",
                          style: lv1TextStyleWhite,
                        ),
                        TextSpan(text: "latest ", style: lv1TextStyleWhiteBold),
                        TextSpan(
                          text: "notification was about ",
                          style: lv1TextStyleWhite,
                        ),
                        TextSpan(
                          text: lastNotification.title,
                          style: lv1TextStyleWhiteBold,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
      ),
    );
  }
}
