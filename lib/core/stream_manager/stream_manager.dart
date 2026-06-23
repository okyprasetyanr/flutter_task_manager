import 'dart:async';

import 'package:task_manager/core/services/local_database/enum/enum.dart';

class StreamManager {
  final Map<EnumTable, StreamSubscription> streamSubsc = {};

  void addStreamSubsc(EnumTable key, StreamSubscription value) {
    if (streamSubsc.containsKey(key)) {
      streamSubsc[key]?.cancel();
    }
    streamSubsc[key] = value;
  }

  void clearStreamSubsc() {
    for (var sub in streamSubsc.values) {
      sub.cancel();
    }
    streamSubsc.clear();
  }
}
