// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:supabase_flutter/supabase_flutter.dart';

class ResponseWrapper {
  Future<Map<String, dynamic>> wrap({
    required Future<dynamic> Function() getData,
  }) async {
    try {
      return {
        'status': 'success',
        'message': "Sukses",
        'results': await getData(),
      };
    } on PostgrestException catch (error) {
      return {'status': 'failed', 'message': error.message, 'results': []};
    } catch (e) {
      return {'status': 'error', 'message': e.toString(), 'results': []};
    }
  }
}
