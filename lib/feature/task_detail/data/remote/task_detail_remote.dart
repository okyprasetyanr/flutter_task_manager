// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class TaskDetailRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;
  TaskDetailRemote({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  Future<List<Map<String, dynamic>>> getAllComment({
    required String companyId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.comments.value)
          .select()
          .eq(EnumComment.taskId.value, companyId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log WorkspaceRemote: Error: $e");
      rethrow;
    }
  }

  void removeCommentChannel(RealtimeChannel commentChannel) {
    supabaseClient.removeChannel(commentChannel);
  }

  RealtimeChannel buildCommentChannel(String taskId) {
    return supabaseClient.channel('public:${EnumTable.comments.value}:$taskId');
  }

  Future<Map<String, dynamic>> createWorkspace(
    Map<String, dynamic> data,
  ) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.comments.value)
          .insert(data)
          .select()
          .single(),
    );
  }
}
