// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';
import 'package:task_manager/shared/enum.dart';

class WorkspaceRemote {
  final ResponseWrapper responseWrapper;
  final SupabaseClient supabaseClient;
  WorkspaceRemote({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  Stream<Map<String, dynamic>> watchWorkspaces({required String companyId}) {
    return responseWrapper.wrapStream(
      getStream: () => supabaseClient
          .from(EnumTable.workspaces.value)
          .stream(primaryKey: [EnumWorkspace.id.value])
          .eq(EnumWorkspace.companyId.value, companyId)
          .order(EnumWorkspace.createdAt.value, ascending: false),
    );
  }

  Future<Map<String, dynamic>> createWorkspace(
    Map<String, dynamic> data,
  ) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.workspaces.value)
          .insert(data)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> updateWorkspace(
    Map<String, dynamic> data,
  ) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.workspaces.value)
          .update(data)
          .eq(EnumWorkspace.id.value, data[EnumWorkspace.id.value])
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> deleteWorkspace(String workspaceId) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.workspaces.value)
          .delete()
          .eq(EnumWorkspace.id.value, workspaceId)
          .select()
          .maybeSingle(),
    );
  }
}
