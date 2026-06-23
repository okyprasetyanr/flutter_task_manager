import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/history_task/domain/enum/enum.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_bloc.dart';
import 'package:task_manager/feature/history_task/presentation/bloc/history_task_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/history_task/domain/model/model_task_history.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class HistoryTaskListHistory extends StatelessWidget {
  const HistoryTaskListHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppPropertyColor.white,
      elevation: 2,
      child:
          BlocSelector<
            HistoryTaskBloc,
            HistoryTaskState,
            (Set<ModelHistoryTask>, EnumStatusState, Set<ModelUser>?)
          >(
            selector: (state) => state is HistoryTaskStateLoaded
                ? (state.dataHistoryTask, state.status, state.dataUser)
                : (const {}, EnumStatusState.loading, const {}),
            builder: (context, state) {
              return CustomListViewBuilderV<ModelHistoryTask>(
                status: state.$2,
                data: state.$1.toList(),
                content: (data, _) {
                  final display = data.display(users: state.$3!);
                  final actor =
                      state.$3
                          ?.where((e) => e.id == data.changedBy)
                          .firstOrNull
                          ?.name ??
                      data.changedBy;
                  devLog("Log HistoryTaskUI: listData: dataUser: ${state.$3}");
                  return [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: actor,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' changed '),
                                TextSpan(
                                  text: data.field.text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 4),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${display.oldValue.isEmpty ? "-" : display.oldValue}'
                              ' → '
                              '${display.newValue.isEmpty ? "-" : display.newValue}',
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            HelperDateConvert.toDisplayUI(date: data.changedAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                onPressed: (data) {},
              );
            },
          ),
    );
  }
}
