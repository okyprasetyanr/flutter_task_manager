// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/workspace/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class WorkspaceRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;
  WorkspaceRemote({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  // Stream<Map<String, dynamic>> watchWorkspaces({required String companyId}) {
  //   return responseWrapper.wrapStream(
  //     getStream: () => supabaseClient
  //         .from(EnumTable.workspaces.value)
  //         .stream(primaryKey: [EnumWorkspace.id.value])
  //         .eq(EnumWorkspace.companyId.value, companyId)
  //         .order(EnumWorkspace.createdAt.value, ascending: false),
  //   );
  // }

  // Stream<Map<String, dynamic>> watchMembers({required String companyId}) {
  //   return responseWrapper.wrapStream(
  //     getStream: () => supabaseClient
  //         .from(EnumTable.workspaceMembers.value)
  //         .stream(primaryKey: [EnumWorkspaceMember.id.value])
  //         .eq(EnumWorkspaceMember.companyId.value, companyId),
  //   );
  // }

  Future<List<Map<String, dynamic>>> getAllWorkspaces({
    required String companyId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.workspaces.value)
          .select()
          .eq(EnumWorkspace.companyId.value, companyId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log WorkspaceRemote: Error: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllMembers({
    required String companyId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.workspaceMembers.value)
          .select()
          .eq(EnumWorkspaceMember.companyId.value, companyId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log WorkspaceRemote: Error: $e");
      rethrow;
    }
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

  Future<Map<String, dynamic>> createWorkspaceMember(
    Set<Map<String, dynamic>> data,
  ) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.workspaceMembers.value)
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

  Future<Map<String, dynamic>> deleteWorkspaceMember({
    required List<String> userId,
    required String workspaceId,
  }) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.workspaceMembers.value)
          .delete()
          .eq(EnumWorkspaceMember.workspaceId.value, workspaceId)
          .inFilter(EnumWorkspaceMember.userId.value, userId)
          .select()
          .maybeSingle(),
    );
  }

  void removeWorkspaceChannel(RealtimeChannel workspaceChannel) {
    supabaseClient.removeChannel(workspaceChannel);
  }

  void removeMemberChannel(RealtimeChannel memberChannel) {
    supabaseClient.removeChannel(memberChannel);
  }

  RealtimeChannel buildWorkspaceChannel(String companyId) {
    return supabaseClient.channel(
      'public:${EnumTable.workspaces.value}:$companyId',
    );
  }

  RealtimeChannel buildMemberChannel(String companyId) {
    return supabaseClient.channel(
      'public:${EnumTable.workspaceMembers.value}:$companyId',
    );
  }
}
