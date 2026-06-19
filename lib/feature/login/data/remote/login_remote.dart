// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/core/dummy/dummy_data.dart';
import 'package:task_manager/core/services/response_wrapper/response_wrapper_remote.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class LoginRemote {
  final ResponseWrapperRemote responseWrapper;
  LoginRemote({required this.responseWrapper});

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await responseWrapper.wrap(
      getData: () async {
        return DummyData.loginSuccess;
      },
    );
    devLog("Log CollectorData: Remote: ${data.toString()}");
    return data;
  }
}
