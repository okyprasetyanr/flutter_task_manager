import 'package:supabase_flutter/supabase_flutter.dart';

class ResponseWrapper {
  // 🟢 1. BUAT FUTURE (Tetap utuh pakai gaya lama kamu)
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

  Stream<Map<String, dynamic>> wrapStream({
    required Stream<List<Map<String, dynamic>>> Function() getStream,
  }) {
    return getStream()
        .map((event) {
          return {'status': 'success', 'message': "Sukses", 'results': event};
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
