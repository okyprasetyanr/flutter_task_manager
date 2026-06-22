// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class ActivityRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  ActivityRemote({required this.responseWrapper, required this.supabaseClient});

  void removeActivityChannel(RealtimeChannel historyChannel) {
    supabaseClient.removeChannel(historyChannel);
  }

  RealtimeChannel buildActivityChannel(String workspaceId) {
    return supabaseClient.channel(
      'public:${EnumTable.activities.value}:$workspaceId',
    );
  }

  Future<List<Map<String, dynamic>>> getAllActivities({
    required String workspaceId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.activities.value)
          .select()
          .eq(EnumActivity.workspaceId.value, workspaceId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log ActivityRemote: Error: $e");
      rethrow;
    }
  }
}
