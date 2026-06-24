import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class SubtaskRemoteSource {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  SubtaskRemoteSource({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  Future<List<Map<String, dynamic>>> getAllSubTask({
    required String projectId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.subtasks.value)
          .select()
          .eq(EnumSubtask.projectId.value, projectId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log TaskRemote: Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteSubTask(String labelId) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.subtasks.value)
          .delete()
          .eq(EnumTask.id.value, labelId)
          .select()
          .maybeSingle(),
    );
  }

  void removeSubTaskChannel(RealtimeChannel subTaskChannel) {
    supabaseClient.removeChannel(subTaskChannel);
  }

  RealtimeChannel buildSubTaskChannel(String projectId) {
    return supabaseClient.channel(
      'public:${EnumTable.subtasks.value}:$projectId',
    );
  }
}
