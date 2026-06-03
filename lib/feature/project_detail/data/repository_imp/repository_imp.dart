// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/main_menu/data/models/model_project.dart';
import 'package:task_manager/feature/project_detail/data/data_resource/local/local_repository.dart';
import 'package:task_manager/feature/project_detail/data/data_resource/remote/remote_repository.dart';
import 'package:task_manager/feature/project_detail/data/model/model_project_detail.dart';
import 'package:task_manager/feature/project_detail/domain/repository/project_detail_repository.dart';

class ProjectDetailRepositoryImp implements ProjectDetailRepository {
  final RemoteProjectDetail remote;
  final LocalProjectDetail local;
  final ModelProject project;

  ProjectDetailRepositoryImp({
    required this.remote,
    required this.local,
    required this.project,
  });

  @override
  Future<ModelProjectDetail> getData() async {
    return await remote.getProjectDetail(project);
  }
}
