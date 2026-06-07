import 'package:task_manager/core/services/api_service/api_services.dart';
import 'package:task_manager/shared/enum.dart';

class ProjectDetailRemote {
  final ApiServices apiServices;

  ProjectDetailRemote({required this.apiServices});

  Future<Map<String, dynamic>> getProjectDetail({
    required String projectId,
    required String companyId,
  }) async {
    final dataProjectMember = await apiServices.getProjectMember(
      projectId,
      companyId,
    );
    final dataTask = await apiServices.getTasks(companyId, projectId);
    final dataSubTask = await Future.wait(
      (dataTask['results'] as List)
          .map(
            (e) =>
                apiServices.getSubTasks(companyId, e[EnumSubTask.taskId.value]),
          )
          .toList(),
    );

    final dataLabel = await apiServices.getLabel(companyId);

    final data = {
      'status': "success",
      'message': '',
      'results': {
        'project_member': [...dataProjectMember['results']],
        'task': [...dataTask['results']],
        'sub_task': [...dataSubTask],
        'label': [...dataLabel['results']],
      },
    };

    return data;
  }
}
