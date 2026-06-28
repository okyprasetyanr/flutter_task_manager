import 'dart:async';

import 'package:task_manager/core/services/local_database/enum/enum.dart';

mixin StreamSubscriptionManager {
  final Map<EnumTable, StreamSubscription> _streamSubscriptions = {};

  void addStreamSubscription(EnumTable key, StreamSubscription subscription) {
    _streamSubscriptions[key]?.cancel();
    _streamSubscriptions[key] = subscription;
  }

  void cancelStreamSubscription(EnumTable key) {
    _streamSubscriptions.remove(key)?.cancel();
  }

  void clearStreamSubscriptions() {
    for (final sub in _streamSubscriptions.values) {
      sub.cancel();
    }
    _streamSubscriptions.clear();
  }
}
