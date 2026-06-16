// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper.dart';
import 'package:task_manager/shared/enum.dart';

class UserRemote {
  final ResponseWrapper responseWrapper;
  final SupabaseClient supabaseClient;

  UserRemote({required this.responseWrapper, required this.supabaseClient});

  Stream<Map<String, dynamic>> watchUser({required String companyId}) {
    return responseWrapper.wrapStream(
      getStream: () => supabaseClient
          .from(EnumTable.users.value)
          .stream(primaryKey: [EnumUser.id.value])
          .eq(EnumUser.companyId.value, companyId)
          .order(EnumUser.name.value, ascending: false),
    );
  }
}
