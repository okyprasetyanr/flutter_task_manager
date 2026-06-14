// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';
import 'package:task_manager/shared/enum.dart';

class WorkspaceRemote {
  final ResponseWrapper responseWrapper;

  WorkspaceRemote({required this.responseWrapper});
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Stream<Map<String, dynamic>> watchWorkspaces({required String companyId}) {
    return responseWrapper.wrapStream(
      getStream: () => _supabaseClient
          .from('workspaces')
          .stream(primaryKey: ['id'])
          .eq('company_id', companyId)
          .order('created_at', ascending: false),
    );
  }

  Future<Map<String, dynamic>> createWorkspace(
    Map<String, dynamic> data,
  ) async {
    return await responseWrapper.wrap(
      getData: () async =>
          _supabaseClient.from('workspaces').insert(data).select().single(),
    );
  }

  Future<Map<String, dynamic>> updateWorkspace(
    Map<String, dynamic> data,
  ) async {
    return await responseWrapper.wrap(
      getData: () async => _supabaseClient
          .from('workspaces')
          .update(data)
          .eq(EnumWorkspace.id.value, data[EnumWorkspace.id.value])
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> deleteWorkspace(String workspaceId) async {
    return await responseWrapper.wrap(
      getData: () async => _supabaseClient
          .from('workspaces')
          .delete()
          .eq(EnumWorkspace.id.value, workspaceId)
          .select()
          .maybeSingle(),
    );
  }
}
