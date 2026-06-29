// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/login/domain/enum/enum.dart';
import 'package:task_manager/feature/shared_component/user/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class LoginRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;
  LoginRemote({required this.responseWrapper, required this.supabaseClient});

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await responseWrapper.wrap(
      getData: () async {
        await supabaseClient.auth.signInWithPassword(
          email: email,
          password: password,
        );
        final dataLogin = supabaseClient.auth.currentUser;
        return await supabaseClient
            .from(EnumTable.users.value)
            .select()
            .eq(EnumUser.id.value, dataLogin!.id)
            .single();
      },
    );
    devLog("Log LoginRemote: data: login: ${data.toString()}");
    return data;
  }

  Future<Map<String, dynamic>> getCompany({required String companyId}) async {
    final data = await responseWrapper.wrap(
      getData: () async {
        return await supabaseClient
            .from(EnumTable.companies.value)
            .select()
            .eq(EnumCompany.companyId.value, companyId)
            .single();
      },
    );
    devLog(
      "Log LoginRemote: data: company: ${data.toString()}, id: $companyId",
    );
    return data;
  }

  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }
}
