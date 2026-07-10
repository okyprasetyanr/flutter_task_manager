import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/activity/domain/enum/enum.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_bloc.dart';
import 'package:task_manager/feature/activity/presentation/bloc/activity_state.dart';
import 'package:task_manager/shared/common_widget/listview/custom_handler_list_v.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/feature/activity/domain/model/model_activity.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/style/text_size.dart';

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
              return CustomHandlerList<ModelActivity>(
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
                        TextSpan(text: actor, style: lv1TextStyleBold),
                        TextSpan(text: ' changed ', style: lv1TextStyle),
                        TextSpan(
                          text: data.action.text.toLowerCase(),
                          style: lv1TextStyleBold,
                        ),
                      ];
                    } else {
                      return [
                        TextSpan(text: actor, style: lv1TextStyleBold),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: data.action.text,
                          style: lv1TextStyleBold,
                        ),
                      ];
                    }
                  }

                  return [
                    Text.rich(
                      TextSpan(
                        style: lv1TextStyleBold,
                        children: buildTextSpans(),
                      ),
                    ),
                    const SizedBox(height: 5),
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
                              style: lv1TextStyleBold,
                            )
                          : Text(
                              display.newValue.isEmpty
                                  ? display.oldValue
                                  : display.newValue,
                              style: lv05TextStyleBoldItalic,
                            ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      HelperDateConvert.toDisplayUI(
                        date: data.createdAt,
                        withMinute: true,
                      ),
                      style: lv05TextStyle,
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
