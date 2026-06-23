import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/activity/domain/enum/enum.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_bloc.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/activity/domain/model/model_activity.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class ActivittyListActivity extends StatelessWidget {
  const ActivittyListActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppPropertyColor.white,
      elevation: 2,
      child:
          BlocSelector<
            ActivityBloc,
            ActivityState,
            (Set<ModelActivity>, EnumStatusState)
          >(
            selector: (state) => state is ActivityStateLoaded
                ? (state.dataActivity, state.status)
                : (const {}, EnumStatusState.loading),
            builder: (context, state) {
              return CustomListViewBuilderV<ModelActivity>(
                status: state.$2,
                data: state.$1.toList(),
                content: (data, _) {
                  final bloc = context.read<ActivityBloc>().state;
                  final users = bloc is ActivityStateLoaded
                      ? bloc.dataUser
                      : const <ModelUser>{};
                  final display = data.display(users: users);

                  final actor =
                      users
                          .where((e) => e.id == data.userId)
                          .firstOrNull
                          ?.name ??
                      data.userId;

                  final isModifierAction =
                      data.action == EnumActivityAction.updateStatus ||
                      data.action == EnumActivityAction.updatePriority ||
                      data.action == EnumActivityAction.updateTask;

                  List<TextSpan> buildTextSpans() {
                    if (isModifierAction) {
                      return [
                        TextSpan(
                          text: actor,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' changed '),
                        TextSpan(
                          text: data.action.text.toLowerCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ];
                    } else {
                      return [
                        TextSpan(
                          text: actor,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: data.action.text,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ];
                    }
                  }

                  return [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: buildTextSpans(),
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
                      child: isModifierAction
                          ? Text(
                              '${display.oldValue.isEmpty ? "-" : display.oldValue}  →  ${display.newValue.isEmpty ? "-" : display.newValue}',
                              style: const TextStyle(fontSize: 13),
                            )
                          : Text(
                              display.newValue.isEmpty
                                  ? display.oldValue
                                  : display.newValue,
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      HelperDateConvert.toDisplayUI(
                        date: data.createdAt,
                        withMinute: true,
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
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
