// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

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
    required List<String> projectIds,
  }) {
    devLog("Log WorkspaceDetailRemote: watchProjectMember: $projectIds");
    return responseWrapper.wrapStream(
      getStream: () => supabaseClient
          .from(EnumTable.projectMembers.value)
          .stream(primaryKey: [EnumProjectMember.id.value])
          .eq(EnumProjectMember.projectId.value, projectIds),
    );
  }
}
