// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/bloc/not_log_bloc.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/presentation/bloc/not_log_event.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading_linear.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

class NotLogListNotification extends StatelessWidget {
  final Set<ModelNotification> data;
  final EnumStatusState status;
  final ScrollController controller;
  const NotLogListNotification({
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
                const SizedBox(width: 50, child: const CustomLoadingLinear()),
            ],
          ),

          Expanded(
            child: CustomListViewBuilderV<ModelNotification>(
              controller: controller,
              status: status,
              data: data.toList(),
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
              onPressed: (data) => context.read<NotLogBloc>().add(
                NotLogEventUpdateIsRead(notificationId: data.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
