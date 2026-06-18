import 'package:drift/native.dart';

class ResponseWrapperLocal {
  Map<String, dynamic> wrap({required dynamic Function() getData}) {
    try {
      return {'status': 'success', 'message': "Success", 'results': getData()};
    } on SqliteException catch (error) {
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
          if (error is SqliteException) {
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
