import 'package:task_manager/core/services/api_service/api_services.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

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
    final dataUser = await apiServices.getUser(companyId);

    final dataMember = const [];
    for (final member in dataProjectMember['results'] as List) {
      for (final user in dataUser['results'] as List) {
        if (member['user_id'] == user['id'] &&
            member['project_id'] == projectId) {
          dataMember.add(user as Map<String, dynamic>);
        }
      }
    }

    final dataTask = await apiServices.getTasks(companyId, projectId);
    final finalTask = const [];
    for (final task in dataTask['results'] as List) {
      if (task['project_id'] == projectId) {
        finalTask.add(task);
      }
    }

    final dataSubTask = await apiServices.getSubTasks(companyId, '');
    final finalSubTask = const [];
    for (final task in finalTask) {
      for (final subTask in dataSubTask['results'] as List) {
        if (subTask['task_id'] == task['id']) {
          finalSubTask.add(subTask as Map<String, dynamic>);
        }
      }
    }

    final dataLabel = await apiServices.getLabel(companyId);
    final finalLabel = const [];
    for (final task in finalTask) {
      final labelIds = List<String>.from(task['label_ids'] ?? const []);

      finalLabel.addAll(
        (dataLabel['results'] as List).where((e) => labelIds.contains(e['id'])),
      );
    }

    final data = {
      'status': "success",
      'message': '',
      'results': {
        'project_member': [...dataMember],
        'task': [...finalTask],
        'sub_task': [...finalSubTask],
        'label': [...finalLabel],
      },
    };
    devLog("Log ProjectDetailRemote: data: $finalLabel");
    return data;
  }
}
