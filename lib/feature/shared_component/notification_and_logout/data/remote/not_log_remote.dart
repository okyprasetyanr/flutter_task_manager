// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';

import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class NotLogRemote {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  NotLogRemote({required this.responseWrapper, required this.supabaseClient});

  Future<List<Map<String, dynamic>>> getAllNotification({
    required String userId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.notifications.value)
          .select()
          .eq(EnumNotification.userId.value, userId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log NotificationRemote: Error: $e");
      rethrow;
    }
  }

  void removeNotificationChannel(RealtimeChannel notificationChannel) {
    supabaseClient.removeChannel(notificationChannel);
  }

  RealtimeChannel buildNotificationChannel(String userId) {
    return supabaseClient.channel(
      'public:${EnumTable.notifications.value}:$userId',
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
