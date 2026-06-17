// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';
import 'package:task_manager/shared/enum.dart';

class WorkspaceDetailRemote {
  final ResponseWrapper responseWrapper;
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

  Stream<Map<String, dynamic>> watchProjectMember({
    required String workspaceId,
  }) {
    return responseWrapper.wrapStream(
      getStream: () => supabaseClient
          .from(EnumTable.projectMembers.value)
          .stream(primaryKey: [EnumProjectMember.id.value])
          .eq('workspace_id', workspaceId),
    );
  }

  Future<Map<String, dynamic>> createProject({
    required Map<String, dynamic> data,
  }) {
    return responseWrapper.wrap(
      getData: () => supabaseClient
          .from(EnumTable.projects.value)
          .insert(data)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> updateProject(Map<String, dynamic> data) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.projects.value)
          .update(data)
          .eq(EnumProject.id.value, data[EnumProject.id.value])
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> updateProjectMember(
    List<Map<String, dynamic>> data,
  ) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.projectMembers.value)
          .insert(data)
          .select()
          .single(),
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
          .from(EnumTable.projects.value)
          .delete()
          .eq(EnumProjectMember.projectId.value, projectId)
          .inFilter(EnumProjectMember.userId.value, userId)
          .select()
          .maybeSingle(),
    );
  }
}
