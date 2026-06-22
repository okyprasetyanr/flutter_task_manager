import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class HistoryTaskRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  HistoryTaskRemote({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  void removeHistoryChannel(RealtimeChannel historyChannel) {
    supabaseClient.removeChannel(historyChannel);
  }

  RealtimeChannel buildHistoryChannel(String workspaceId) {
    return supabaseClient.channel(
      'public:${EnumTable.taskHistories.value}:$workspaceId',
    );
  }

  Future<List<Map<String, dynamic>>> getAllHistories({
    required String workspaceId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.taskHistories.value)
          .select()
          .eq(EnumHistoryTask.workspaceId.value, workspaceId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log HistoryRemote: Error: $e");
      rethrow;
    }
  }
}
