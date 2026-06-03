// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:task_manager/core/services/api_services.dart';
import 'package:task_manager/feature/project_detail/data/model/model_members.dart';
import 'package:task_manager/feature/project_detail/data/model/model_project_detail.dart';
import 'package:task_manager/feature/main_menu/data/models/model_project.dart';
import 'package:task_manager/feature/project_detail/data/model/model_tasks.dart';

class RemoteProjectDetail {
  final ApiServices apiServices;

  RemoteProjectDetail({required this.apiServices});

  FutureOr<ModelProjectDetail> getProjectDetail(ModelProject project) async {
    final data = await apiServices.getProjectDetail(project.projectId);
    return ModelProjectDetail(
      project: project,
      member: (data['members'] as List)
          .map((e) => ModelProjectMember.fromJson(e))
          .toList(),
      task: (data['tasks'] as List)
          .map((e) => ModelProjectTask.fromJson(e))
          .toList(),
    );
  }
}
