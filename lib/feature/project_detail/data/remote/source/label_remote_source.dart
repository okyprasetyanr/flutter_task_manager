import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/core/services/local_database/enum/enum.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class LabelRemoteSource {
  final ResponseWrapperRemote responseWrapper;
  final SupabaseClient supabaseClient;

  LabelRemoteSource({
    required this.responseWrapper,
    required this.supabaseClient,
  });

  Future<List<Map<String, dynamic>>> getAllLabel({
    required String companyId,
  }) async {
    try {
      final response = await supabaseClient
          .from(EnumTable.labels.value)
          .select()
          .eq(EnumLabel.companyId.value, companyId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      devLog("Log TaskRemote: Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteLabel(String labelId) async {
    return await responseWrapper.wrap(
      getData: () async => supabaseClient
          .from(EnumTable.labels.value)
          .delete()
          .eq(EnumTask.id.value, labelId)
          .select()
          .maybeSingle(),
    );
  }

  void removeLabelChannel(RealtimeChannel labelChannel) {
    supabaseClient.removeChannel(labelChannel);
  }

  RealtimeChannel buildLabelChannel(String companyId) {
    return supabaseClient.channel(
      'public:${EnumTable.labels.value}:$companyId',
    );
  }
}
