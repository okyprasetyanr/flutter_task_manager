// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/task_detail/domain/enum/enum.dart';
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
      devLog("Log CommentRemote: Error: $e");
      rethrow;
    }
  }

  void removeCommentChannel(RealtimeChannel commentChannel) {
    supabaseClient.removeChannel(commentChannel);
  }

  RealtimeChannel buildCommentChannel(String taskId) {
    return supabaseClient.channel('public:${EnumTable.comments.value}:$taskId');
  }

  Future<Map<String, dynamic>> createComment(Map<String, dynamic> data) async {
    devLog("Log CommentRemote: createComment: $data");
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.comments.value)
          .insert(data)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.comments.value)
          .delete()
          .eq(EnumComment.id.value, commentId)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> createSubtask(Map<String, dynamic> data) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.subtasks.value)
          .insert(data)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> deleteSubtaskt(String subtaskId) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.subtasks.value)
          .delete()
          .eq(EnumSubtask.id.value, subtaskId)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> updateSubtaskt(Map<String, dynamic> data) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.subtasks.value)
          .update(data)
          .eq(EnumSubtask.id.value, data[EnumSubtask.id.value])
          .select()
          .single(),
    );
  }
}
