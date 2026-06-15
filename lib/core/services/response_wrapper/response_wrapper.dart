import 'package:supabase_flutter/supabase_flutter.dart';

class ResponseWrapper {
  Future<Map<String, dynamic>> wrap({
    required Future<dynamic> Function() getData,
  }) async {
    try {
      return {
        'status': 'success',
        'message': "Success",
        'results': await getData(),
      };
    } on PostgrestException catch (error) {
      return {'status': 'failed', 'message': error.message, 'results': []};
    } catch (e) {
      return {'status': 'error', 'message': e.toString(), 'results': []};
    }
  }

  Stream<Map<String, dynamic>> wrapStream({
    required Stream<List<Map<String, dynamic>>> Function() getStream,
  }) {
    return getStream()
        .map((event) {
          return {'status': 'success', 'message': "Success", 'results': event};
        })
        .handleError((error) {
          if (error is PostgrestException) {
            return {
              'status': 'failed',
              'message': error.message,
              'results': [],
            };
          }
          return {
            'status': 'error',
            'message': error.toString(),
            'results': [],
          };
        });
  }
}
