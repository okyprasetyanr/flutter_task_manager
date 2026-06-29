import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_merge.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/feature/workspace_detail/domain/model/model_project_member.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class ProjectDetailListMember extends StatefulWidget {
  const ProjectDetailListMember({super.key});

  @override
  State<ProjectDetailListMember> createState() =>
      _ProjectDetailListMemberState();
}

class _ProjectDetailListMemberState extends State<ProjectDetailListMember> {
  final dataUser = <(ModelUser, EnumProjectRole)>{}.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Material(
            borderRadius: BorderRadius.circular(8),
            elevation: 2,
            color: AppPropertyColor.white,
            child:
                BlocSelector<
                  ProjectDetailBloc,
                  ProjectDetailState,
                  (Set<ModelProjectMember>, EnumStatusState, Set<ModelUser>)
                >(
                  selector: (state) => state is ProjectDetailStateLoaded
                      ? (
                          state.dataProject?.dataMember ?? const {},
                          state.status,
                          state.dataUser,
                        )
                      : (const {}, EnumStatusState.loading, const {}),
                  builder: (context, state) {
                    final memberRole = {
                      for (final member in state.$1) member.userId: member.role,
                    };

                    dataUser.addAll(
                      state.$3
                          .where((user) => memberRole.containsKey(user.id))
                          .map((user) => (user, memberRole[user.id]!))
                          .toSet(),
                    );
                    return Column(
                      children: [
                        Expanded(
                          child:
                              CustomListViewBuilderV<
                                (ModelUser, EnumProjectRole)
                              >(
                                smallSpace: true,
                                status: state.$2,
                                data: dataUser.toList(),
                                content: (data, _) => [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.$1.name,
                                        style: lv05TextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        data.$1.email,
                                        style: lv05TextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppPropertyColor.primary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        data.$2.text,
                                        style: lv05TextStyleWhite,
                                      ),
                                    ),
                                  ),
                                ],
                                onPressed: (data) => {},
                              ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: AppPropertyColor.white,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(10),
                                  children: [
                                    Text("List Member", style: titleTextStyle),
                                    CustomListViewBuilderV<
                                      (ModelUser, EnumProjectRole)
                                    >(
                                      smallSpace: true,
                                      status: EnumStatusState.none,
                                      data: dataUser.toList(),
                                      content: (data, _) => [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data.$1.name,
                                              style: lv05TextStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              data.$1.email,
                                              style: lv05TextStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Material(
                                          elevation: 2,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: AppPropertyColor.primary,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              data.$2.text,
                                              style: lv05TextStyleWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                      onPressed: (data) => {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: Material(
                              color: AppPropertyColor.primary,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Show All Member",
                                  style: lv1TextStyleWhite,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
          ),
        ),

        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Card(
            color: AppPropertyColor.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child:
                  BlocSelector<
                    ProjectDetailBloc,
                    ProjectDetailState,
                    Set<ModelTaskMerge>?
                  >(
                    selector: (state) => state is ProjectDetailStateLoaded
                        ? state.dataTask
                        : null,
                    builder: (context, state) {
                      int totalTask = 0;
                      int completedTask = 0;
                      if (state != null) {
                        for (final task in state) {
                          if (task.dataSubTask.isNotEmpty) {
                            totalTask += task.dataSubTask.length;
                            for (final subtask in task.dataSubTask) {
                              if (subtask.isDone) {
                                completedTask++;
                              }
                            }
                          } else {
                            totalTask++;
                            if (task.dataTask.status == EnumTaskStatus.done) {
                              completedTask++;
                            }
                          }
                        }
                      }

                      final dueDate = DateTime(2026, 7, 10);
                      final today = DateTime.now();

                      final remainingDays = dueDate.difference(today).inDays;
                      final progress = totalTask == 0
                          ? 0.0
                          : completedTask / totalTask;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Project Progress",
                                style: lv05TextStyleBold,
                              ),
                              Text(
                                "${(progress * 100).toStringAsFixed(0)}%",
                                style: lv05TextStyleBold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 12,
                              backgroundColor: AppPropertyColor.greyLight,
                              valueColor: AlwaysStoppedAnimation(
                                AppPropertyColor.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                "$completedTask from $totalTask task is Done",
                                style: lv05TextStyle,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "$remainingDays days left",
                                style: lv05TextStyle,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
