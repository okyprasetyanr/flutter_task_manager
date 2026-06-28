import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class ResponseWrapperRemote {
  Future<Map<String, dynamic>> wrap({
    required Future<dynamic> Function() getData,
  }) async {
    try {
      return {
        'status': 'success',
        'message': 'Success',
        'results': await getData(),
      };
    } on PostgrestException catch (error) {
      String message;

      switch (error.code) {
        case '23505':
          message = 'Data already exists.';
          break;

        case '23503':
          message = 'Related data not found.';
          break;

        case '23502':
          message = 'Required data is missing.';
          break;

        case '23514':
          message = 'Invalid data.';
          break;

        case '22P02':
          message = 'Invalid input format.';
          break;

        case '22001':
          message = 'Text is too long.';
          break;

        case '42501':
          message = 'Permission denied.';
          break;

        case 'PGRST116':
          message = 'Data not found.';
          break;

        default:
          message = error.message;
          break;
      }

      return {'status': 'failed', 'message': message, 'results': []};
    } on TimeoutException {
      return {
        'status': 'error',
        'message': 'Request timed out.',
        'results': [],
      };
    } on SocketException {
      return {
        'status': 'error',
        'message': 'No internet connection.',
        'results': [],
      };
    } on FormatException {
      return {
        'status': 'error',
        'message': 'Invalid data format.',
        'results': [],
      };
    } on AuthException catch (error) {
      switch (error.code) {
        case 'invalid_credentials':
          return {
            'status': 'failed',
            'message': 'Invalid email or password.',
            'results': [],
          };

        case 'email_not_confirmed':
          return {
            'status': 'failed',
            'message': 'Please verify your email.',
            'results': [],
          };

        case 'user_already_exists':
        case 'email_exists':
          return {
            'status': 'failed',
            'message': 'Email already exists.',
            'results': [],
          };

        default:
          devLog("Log ResponseWrapperRemote: error: ${error.message}");
          return {'status': 'failed', 'message': error.message, 'results': []};
      }
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
