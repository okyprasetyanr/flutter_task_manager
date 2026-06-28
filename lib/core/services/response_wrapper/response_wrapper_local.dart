import 'package:drift/native.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class ResponseWrapperLocal {
  Map<String, dynamic> wrap({required dynamic Function() getData}) {
    try {
      return {'status': 'success', 'message': 'Success', 'results': getData()};
    } on SqliteException catch (error) {
      final message = error.message.toLowerCase();

      String displayMessage;

      if (message.contains('unique constraint')) {
        displayMessage = 'Data already exists.';
      } else if (message.contains('foreign key')) {
        displayMessage = 'Related data not found.';
      } else if (message.contains('not null')) {
        displayMessage = 'Required data is missing.';
      } else if (message.contains('check constraint')) {
        displayMessage = 'Invalid data.';
      } else if (message.contains('no such table')) {
        displayMessage = 'Table not found.';
      } else if (message.contains('no such column')) {
        displayMessage = 'Column not found.';
      } else if (message.contains('database is locked')) {
        displayMessage = 'Database is busy.';
      } else if (message.contains('syntax error')) {
        displayMessage = 'Database query error.';
      } else {
        displayMessage = error.message;
      }

      return {'status': 'failed', 'message': displayMessage, 'results': []};
    } on FormatException {
      return {
        'status': 'error',
        'message': 'Invalid data format.',
        'results': [],
      };
    } catch (e) {
      devLog('Log ResponseWrapper: SQLite Wrap Error: $e');

      return {
        'status': 'error',
        'message': 'Something went wrong.',
        'results': [],
      };
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
