import 'package:task_manager/feature/main_menu/data/data_resource/local/get_workspace.dart';
import 'package:task_manager/feature/main_menu/data/data_resource/remote/get_workspace.dart';
import 'package:task_manager/feature/main_menu/domain/repository/repository.dart';
import 'package:task_manager/feature/main_menu/data/models/model_project.dart';

class RepositoryWorkSpaceImp implements RepositoryWorkSpace {
  final RemoteMainMenu remote;
  final LocalMainMenu local;

  RepositoryWorkSpaceImp({required this.local, required this.remote});

  @override
  Future<List<ModelProject>> getProject() async {
    return await remote.getProject();
  }
}
