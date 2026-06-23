// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/shared_component/notification/domain/enum/enum.dart';

class NotificationRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  NotificationRemote({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  Stream<Map<String, dynamic>> watchNotification({required String userId}) {
    return responseWrapper.wrapStream(
      getStream: () => supabaseClient
          .from(EnumTable.notifications.value)
          .stream(primaryKey: [EnumNotification.id.value])
          .eq(EnumNotification.userId.value, userId)
          .order(EnumNotification.createdAt.value, ascending: false),
    );
  }

  Future<Map<String, dynamic>> updateNotification({
    required Map<String, dynamic> data,
  }) async {
    return await responseWrapper.wrap(
      getData: () => supabaseClient
          .from(EnumTable.notifications.value)
          .update(data)
          .eq(EnumNotification.id.value, data[EnumNotification.id.value])
          .select()
          .single(),
    );
  }
}
