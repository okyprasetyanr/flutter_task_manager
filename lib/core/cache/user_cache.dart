// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

class UserCache {
  Set<ModelUser> user;
  UserCache({required this.user});

  Set<ModelUser> getUser() {
    return user;
  }

  void setUser(Set<ModelUser> data) {
    user = data;
  }
}
