// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_bloc.dart';
import 'package:task_manager/feature/shared_component/notification/presentation/bloc/notification_event.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/shared_component/notification/domain/model/model_notification.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/listview/custom_list_view_builder_v.dart';
import 'package:task_manager/shared/widget/loading/custom_loading.dart';
import 'package:task_manager/shared/widget/text/custom_text_empty.dart';

class NotificationListNotification extends StatelessWidget {
  final List<ModelNotification> data;
  final EnumStatusState status;
  final ScrollController controller;
  const NotificationListNotification({
    super.key,
    required this.data,
    required this.status,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notification List", style: titleTextStyle),
              if (status == EnumStatusState.synchronize)
                const SizedBox(width: 50, child: CustomLoading()),
            ],
          ),

          Expanded(
            child: CustomListViewBuilderV<ModelNotification>(
              controller: controller,
              status: status,
              data: data,
              content: (data, status) {
                if (status != EnumStatusState.loading) {
                  return [
                    Row(
                      children: [
                        Expanded(
                          child: Text(data.title, style: lv1TextStyleBold),
                        ),
                        if (!data.isRead)
                          Text("New!", style: lv05TextStyleRedPrice),
                      ],
                    ),
                    Text(data.body, style: lv05TextStyle),
                    Text(HelperDateConvert.toDisplayUI(date: data.createdAt)),
                  ];
                }
                return [CustomTextEmpty()];
              },
              onPressed: (data) => context.read<NotificationBloc>().add(
                NotificationEventUpdateIsRead(notificationId: data.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
