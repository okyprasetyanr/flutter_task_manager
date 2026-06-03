import 'package:task_manager/core/services/api_services.dart';
import 'package:task_manager/feature/main_menu/data/models/model_project.dart';

class RemoteMainMenu {
  final ApiServices api;

  RemoteMainMenu({required this.api});

  Future<List<ModelProject>> getProject() async {
    final data = await api.getProject("", "");
    return data.map((e) => ModelProject.fromJson(e)).toList();
  }
}
