// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceDetailRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  WorkspaceDetailRemote({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  Stream<Map<String, dynamic>> watchProject({required String workspaceId}) {
    return responseWrapper.wrapStream(
      getStream: () => supabaseClient
          .from(EnumTable.projects.value)
          .stream(primaryKey: [EnumProject.id.value])
          .eq(EnumProject.workspaceId.value, workspaceId)
          .order(EnumProject.end.value, ascending: false),
    );
  }

  Stream<Map<String, dynamic>> watchMember({required String workspaceId}) {
    return responseWrapper.wrapStream(
      getStream: () => supabaseClient
          .from(EnumTable.projectMembers.value)
          .stream(primaryKey: [EnumProjectMember.id.value])
          .eq('workspace_id', workspaceId),
    );
  }

  Future<List<Map<String, dynamic>>> getAllProjects({
    required String workspaceId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.projects.value)
          .select()
          .eq(EnumProject.workspaceId.value, workspaceId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log ProjectRemote: Error: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllMembers({
    required String workspaceId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.projectMembers.value)
          .select()
          .eq(EnumProjectMember.workspaceId.value, workspaceId);

      devLog("Log ProjectRemote: getAllMember: $response");
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log ProjectRemote: Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createProject({
    required Map<String, dynamic> data,
  }) async {
    devLog(
      "Log WorkspaceDetailRemote: createProject: data: ${data.toString()}",
    );
    return responseWrapper.wrap(
      getData: () => supabaseClient
          .from(EnumTable.projects.value)
          .insert(data)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> updateProject(Map<String, dynamic> data) async {
    devLog(
      "Log WorkspaceDetailRemote: updateProject: data: ${data.toString()}",
    );
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.projects.value)
          .update(data)
          .eq(EnumProject.id.value, data[EnumProject.id.value])
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> createProjectMember(
    Set<Map<String, dynamic>> data,
  ) async {
    devLog(
      "Log WorkspaceDetailRemote: createProjectMember: data: ${data.toString()}",
    );
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.projectMembers.value)
          .insert(data.toList())
          .select(),
    );
  }

  Future<Map<String, dynamic>> updateProjectMember(
    Set<Map<String, dynamic>> data,
  ) async {
    devLog(
      "Log WorkspaceDetailRemote: updateProject: data: ${data.toString()}",
    );
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.projectMembers.value)
          .upsert(data.toList())
          .select(),
    );
  }

  Future<Map<String, dynamic>> deleteProject(String idProject) async {
    return await responseWrapper.wrap(
      getData: () => supabaseClient
          .from(EnumTable.projects.value)
          .delete()
          .eq(EnumProject.id.value, idProject)
          .select()
          .maybeSingle(),
    );
  }

  Future<Map<String, dynamic>> deleteProjectMember(
    List<String> userId,
    String projectId,
  ) async {
    return await responseWrapper.wrap(
      getData: () => supabaseClient
          .from(EnumTable.projectMembers.value)
          .delete()
          .eq(EnumProjectMember.projectId.value, projectId)
          .inFilter(EnumProjectMember.userId.value, userId)
          .select()
          .maybeSingle(),
    );
  }

  void removeProjectChannel(RealtimeChannel projectChannel) {
    supabaseClient.removeChannel(projectChannel);
  }

  void removeMemberChannel(RealtimeChannel memberChannel) {
    supabaseClient.removeChannel(memberChannel);
  }

  RealtimeChannel buildProjectChannel(String workspaceId) {
    return supabaseClient.channel(
      'public:${EnumTable.projects.value}:$workspaceId',
    );
  }

  RealtimeChannel buildMemberChannel(String workspaceId) {
    return supabaseClient.channel(
      'public:${EnumTable.projectMembers.value}:$workspaceId',
    );
  }
}
