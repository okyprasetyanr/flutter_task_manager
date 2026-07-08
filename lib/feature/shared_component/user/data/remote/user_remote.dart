// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/shared_component/user/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class UserRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  UserRemote({required this.responseWrapper, required this.supabaseClient});

  Future<Map<String, dynamic>> createMember(Map<String, dynamic> data) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.users.value)
          .insert(data)
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> updatemember(Map<String, dynamic> data) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.users.value)
          .update(data)
          .eq(EnumUser.id.value, data[EnumUser.id.value])
          .select()
          .single(),
    );
  }

  Future<Map<String, dynamic>> deleteMember({
    required String userId,
    required String idCompany,
  }) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.users.value)
          .delete()
          .eq(EnumUser.companyId.value, idCompany)
          .eq(EnumUser.id.value, userId)
          .select(),
    );
  }

  Future<List<Map<String, dynamic>>> getAllUser({
    required String companyId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.users.value)
          .select()
          .eq(EnumUser.companyId.value, companyId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log UserRemote: Error: $e");
      rethrow;
    }
  }

  void removeUserChannel(RealtimeChannel userChannel) {
    supabaseClient.removeChannel(userChannel);
  }

  RealtimeChannel buildUserChannel(String companyId) {
    return supabaseClient.channel('public:${EnumTable.users.value}:$companyId');
  }
}
