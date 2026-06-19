// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class UserCache {
  Set<ModelUser> _users = {};

  final _controller = StreamController<Set<ModelUser>>.broadcast();

  Stream<Set<ModelUser>> get stream => _controller.stream;

  Set<ModelUser> get users => _users;

  void setUsers(Set<ModelUser> data) {
    _users = data;
    _controller.add(_users);
  }

  void dispose() {
    _controller.close();
  }
}
