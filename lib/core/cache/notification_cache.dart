import 'package:rxdart/subjects.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/model/model_notification.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class NotificationCache {
  final BehaviorSubject<Set<ModelNotification>> _controller =
      BehaviorSubject.seeded({});

  Stream<Set<ModelNotification>> get stream {
    devLog("Log NotificationCache: stream: data: ${_controller.value.length}");
    return _controller.stream;
  }

  void setNotification(Set<ModelNotification> data) {
    devLog("Log NotificationCache: setNotification: data: ${data.length}");
    if (!_controller.isClosed) {
      _controller.add(data);
    }
  }

  void clear() {
    _controller.add({});
  }

  void dispose() {
    _controller.close();
  }
}
