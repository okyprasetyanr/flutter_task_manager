import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class TaskLabelRemoteSource {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  TaskLabelRemoteSource({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  Future<List<Map<String, dynamic>>> getAllTaskLabel({
    required String projectId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.taskLabels.value)
          .select()
          .eq(EnumTaskLabel.projectId.value, projectId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log TaskRemote: Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createTasklabel(
    Set<Map<String, dynamic>> data,
  ) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.taskLabels.value)
          .insert(data.toList())
          .select(),
    );
  }

  Future<Map<String, dynamic>> deleteTaskLabel(
    Set<String> labelId,
    String taskId,
  ) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.taskLabels.value)
          .delete()
          .eq(EnumTaskLabel.taskId.value, taskId)
          .inFilter(EnumTaskLabel.labelId.value, labelId.toList())
          .select(),
    );
  }

  void removeTaskLabelChannel(RealtimeChannel taskLabelChannel) {
    supabaseClient.removeChannel(taskLabelChannel);
  }

  RealtimeChannel buildTaskLabelChannel(String projectId) {
    return supabaseClient.channel(
      'public:${EnumTable.taskLabels.value}:$projectId',
    );
  }
}
