import 'package:rxdart/rxdart.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/helper/helper_common/helper_common.dart';

class UserCache {
  final _controller = BehaviorSubject<Set<ModelUser>>.seeded({});

  Stream<Set<ModelUser>> get stream {
    devLog("Log UserCache: stream: data: ${_controller.value.length}");
    return _controller.stream;
  }

  Set<ModelUser> get users => _controller.value;

  void setUsers(Set<ModelUser> data) {
    devLog("Log UserCache: setUser: data: ${data.length}");
    _controller.add(data);
  }

  void dispose() {
    _controller.close();
  }
}
