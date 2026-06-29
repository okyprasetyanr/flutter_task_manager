import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';

abstract class UserRepository {
  void watchUser();
  Stream<Set<ModelUser>> getUser();
  Future<void> disposeUserRealtime();
}
