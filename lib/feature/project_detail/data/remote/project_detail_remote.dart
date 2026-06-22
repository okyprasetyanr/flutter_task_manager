// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class ProjectDetailRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  ProjectDetailRemote({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  Future<List<Map<String, dynamic>>> getAllTask({
    required String projectId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.tasks.value)
          .select()
          .eq(EnumTask.projectId.value, projectId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log TaskRemote: Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.tasks.value)
          .insert(data)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> updateTask(Map<String, dynamic> data) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.tasks.value)
          .update(data)
          .eq(EnumTask.id.value, data[EnumTask.id.value])
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> deleteTask(String taskId) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.tasks.value)
          .delete()
          .eq(EnumTask.id.value, taskId)
          .select()
          .maybeSingle(),
    );
  }

  void removeTaskChannel(RealtimeChannel taskChannel) {
    supabaseClient.removeChannel(taskChannel);
  }

  RealtimeChannel buildTaskChannel(String projectId) {
    return supabaseClient.channel('public:${EnumTable.tasks.value}:$projectId');
  }

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

  void removeTaskLabelChannel(RealtimeChannel taskLabelChannel) {
    supabaseClient.removeChannel(taskLabelChannel);
  }

  RealtimeChannel buildTaskLabelChannel(String projectId) {
    return supabaseClient.channel(
      'public:${EnumTable.taskLabels.value}:$projectId',
    );
  }

  Future<List<Map<String, dynamic>>> getAllSubTask({
    required String projectId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.subtasks.value)
          .select()
          .eq(EnumSubTask.projectId.value, projectId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log TaskRemote: Error: $e");
      rethrow;
    }
  }

  void removeSubTaskChannel(RealtimeChannel subTaskChannel) {
    supabaseClient.removeChannel(subTaskChannel);
  }

  RealtimeChannel buildSubTaskChannel(String projectId) {
    return supabaseClient.channel(
      'public:${EnumTable.subtasks.value}:$projectId',
    );
  }

  Future<List<Map<String, dynamic>>> getAllLabel({
    required String companyId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.labels.value)
          .select()
          .eq(EnumLabel.companyId.value, companyId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log TaskRemote: Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteLabel(String labelId) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.labels.value)
          .delete()
          .eq(EnumTask.id.value, labelId)
          .select()
          .maybeSingle(),
    );
  }

  void removeLabelChannel(RealtimeChannel labelChannel) {
    supabaseClient.removeChannel(labelChannel);
  }

  RealtimeChannel buildLabelChannel(String companyId) {
    return supabaseClient.channel(
      'public:${EnumTable.labels.value}:$companyId',
    );
  }
}
