import 'package:task_manager/feature/project_detail/data/model/model_project_detail.dart';

abstract class ProjectDetailRepository {
  Future<ModelProjectDetail> getData();
}
