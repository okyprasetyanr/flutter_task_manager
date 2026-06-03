import 'package:task_manager/feature/main_menu/data/models/model_project.dart';

abstract class RepositoryWorkSpace {
  Future<List<ModelProject>> getProject();
}
